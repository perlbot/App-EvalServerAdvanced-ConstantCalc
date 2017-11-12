package App::EvalServerAdvanced::ConstantCalc;

our $VERSION="0.01";

use v5.24;
use Moo;
use Function::Parameters;
use Data::Dumper;

has constants => (is => 'ro', default => sub {+{}});
has _parser => (is => 'ro', default => sub {App::EvalServerAdvanced::ConstantCalc::Parser->new(consts => $_[0])});

method get_value($key) {
  die "Missing constant [$key]" unless exists($self->constants->{$key});

  return $self->constants->{$key};
}

method add_constant($key, $value) {
  die "Invalid key [$key]" if ($key =~ /\s/ || $key =~ /^\s*\d/);

  if (exists($self->constants->{$key}) && defined(my $eval = $self->constants->{$key})) {
    die "Cannot redefine a constant [$key].  Existing value [$eval] new value [$value]"
  }

  $self->constants->{$key} = $value;
}

method calculate($string) {
  return $self->_parser->from_string($string);
}

package
  App::EvalServerAdvanced::ConstantCalc::Parser;

use strict;
use warnings;

# Ensure we can't accidentally turn to strings, or floats, or anything other than an integer
use integer;
no warnings 'experimental::bitwise';
use feature 'bitwise';

use base qw/Parser::MGC/;
use Function::Parameters;

method new($class: %args) {
  my $consts = delete $args{consts};

  my $self = $class->SUPER::new(%args);

  $self->{_private}{consts} = $consts;

  return $self;
}

method consts() {
  return $self->{_private}{consts};
}

method parse() {
  my $val = $self->parse_term;

   1 while $self->any_of(
      sub {$self->expect("&"); $val &= $self->parse_term; 1},
      sub {$self->expect("^"); $val ^= $self->parse_term; 1},
      sub {$self->expect("|"); $val |= $self->parse_term; 1},
      sub {0});

  return $val;
}

method parse_term() {
   $self->any_of(
      sub { $self->scope_of( "(", sub { $self->parse }, ")" ) },
      sub { $self->expect('~['); my $bitdepth=$self->token_int; $self->expect(']'); my $val = $self->parse_term; (~ ($val & _get_mask($bitdepth))) & _get_mask($bitdepth)},
      sub { $self->expect('~'); ~$self->parse_term},
      sub { $self->token_constant },
      sub { $self->token_int },
   );
}

method token_int() {
  0+$self->any_of(
     sub {_from_hex($self->expect(qr/0x[0-9A-F_]+/i));},
     sub {_from_bin($self->expect(qr/0b[0-7_]+/i));},
     sub {_from_oct($self->expect(qr/0o?[0-7_]+/i));},
     sub {$self->expect(qr/\d+/)}
     );
}

method token_constant() {
  my $const = $self->expect(qr/[a-z_][a-z_0-9]+/i);

  $self->consts->get_value($const);
}

fun _get_mask($size) {
  return 2**($size)-1;
}

fun _from_hex($val) {
  # naively just eval it
  return eval $val;
}

fun _from_oct($val) {
  $val =~ s/^0o/0/i;
  return eval $val;
}

fun _from_bin($val) {
  return eval $val;
}

1;

__END__
