use strict;
use warnings;

use Test::More;
use App::EvalServerAdvanced::ConstantCalc;

my $calc = App::EvalServerAdvanced::ConstantCalc->new();

ok($calc->add_constant("foo", 0x01));
ok($calc->add_constant("bar", 0x02));

is($calc->calculate("foo|bar"), 3);

done_testing;
