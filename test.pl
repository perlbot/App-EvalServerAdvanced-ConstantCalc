use lib './lib';
use App::EvalServerAdvanced::ConstantCalc;


my $foo = App::EvalServerAdvanced::ConstantCalc->new();
$foo->calculate("0x1|2");

