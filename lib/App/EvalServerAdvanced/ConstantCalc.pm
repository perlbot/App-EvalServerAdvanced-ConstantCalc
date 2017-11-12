package App::EvalServerAdvanced::ConstantCalc;
use v5.24;
use Moo;
use Parse::RecDescent;
use Function::Parameters;
use Data::Dumper;

has constants => (is => 'ro', default => sub {+{}});

   $::RD_ERRORS=1;       # unless undefined, report fatal errors
   $::RD_WARN=1;         # unless undefined, also report non-fatal problems
   $::RD_HINT=1;         # if defined, also suggestion remedies
   $::RD_TRACE=1;        # if defined, also trace parsers' behaviour
my $grammar = q{
startrule: expression
OP: /[&|^]/
expression: value OP value { return App::EvalServerAdvanced::ConstantCalc::_expr(@item) } 

value: number {return App::EvalServerAdvanced::ConstantCalc::_parse_num(@item)}
     | identifier {return App::EvalServerAdvanced::ConstantCalc::_identifier(@item)}
number: /0x[0-9a-f]+/i | /0o?[0-7]+/ | /0b[01]+/i | /[0-9]+/ 
identifier: /[a-z][a-z_0-9]*/i
};

fun _expr($type, $lhs, $op, $rhs) {
  say "$lhs $op $rhs";

  return $lhs + $rhs;
}

sub _not_expr {
}

sub _or_expr {
}

fun _parse_num($type, $value) {

  return 777; # TODO
}

fun _identifier($type, $key) {
  say Dumper(\@_);
  say "IDENT: $key";
  return 1;
}

my $parser = Parse::RecDescent->new($grammar);
print Dumper($parser->startrule("1 & 2"));

1;
