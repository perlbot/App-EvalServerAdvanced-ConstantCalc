#!/usr/bin/env perl

use lib './lib';
use App::EvalServerAdvanced::ConstantCalc;

my $foo = App::EvalServerAdvanced::ConstantCalc->new();
$foo->add_constant(O_RDONLY => 0);
$foo->add_constant(O_RDWR => 1);
$foo->add_constant(O_CLOEXEC => 0x10);
printf "%016X\n", $foo->calculate("(O_RDWR|O_CLOEXEC)&7");

