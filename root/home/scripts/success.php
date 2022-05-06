<?php

for ($i = 0; $i < 2; $i++) {
        echo "Hello World $i from " . get_current_user() . PHP_EOL;
        sleep(1);
}