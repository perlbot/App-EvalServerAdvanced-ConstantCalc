#!/usr/bin/env perl

use lib './lib';
use App::EvalServerAdvanced::ConstantCalc;

my $foo = App::EvalServerAdvanced::ConstantCalc->new();
printf "%016X\n", $foo->calculate("0x1^~[16]0xF");

