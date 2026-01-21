<?php $s = '<?php $s = \'...\'; echo strtr($s, [str_repeat(\'.\', 3) => $s]);'; echo strtr($s, [str_repeat('.', 3) => $s]);
