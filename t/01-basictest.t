use strict;
use warnings;

use Test::More;
use App::EvalServerAdvanced::ConstantCalc;

my $calc = App::EvalServerAdvanced::ConstantCalc->new();

$calc->add_constant("foo", 0x01);
$calc->add_constant("bar", 0x02);

$calc->parse("foo|bar") == 3;

done_testing;
