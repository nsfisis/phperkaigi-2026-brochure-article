#!/usr/bin/env bash

set -eu

diff -u src/simple.php         <(php src/simple.php)
diff -u src/illegal-quine.php  <(php src/illegal-quine.php)
diff -u src/illegal-quine2.php <(php src/illegal-quine2.php)
diff -u src/try-quine5.php     <(php src/try-quine5.php)
diff -u src/try-quine6.php     <(php src/try-quine6.php)
diff -u src/quine-japan.php    <(php src/quine-japan.php)

diff -u <(sed -e 's/n=0/n=1/' src/countup-quine.php) <(php src/countup-quine.php)
diff -u <(sed -e 's/n=0/n=2/' src/countup-quine.php) <(php src/countup-quine.php | php)
diff -u <(sed -e 's/n=0/n=3/' src/countup-quine.php) <(php src/countup-quine.php | php | php)

diff -u src/quine-puzzle.php   <(php src/quine-puzzle.php)
diff -u src/quine-puzzle.php   <(php src/quine-puzzle.php l | php -- h)
diff -u src/quine-puzzle.php   <(php src/quine-puzzle.php j | php -- j | php -- k | php -- k)

diff -u src/blanquine.php <(php src/blanquine.php)

echo "All tests passed."
