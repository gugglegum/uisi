<?php

$tests = [
    [ '1 graph1.txt', 'test1_graph1.txt' ],
    [ '1 graph2.txt', 'test1_graph2.txt' ],
    [ '1 graph3.txt', 'test1_graph3.txt' ],
    [ '2 graph1.txt', 'test2_graph1.txt' ],
    [ '2 graph2.txt', 'test2_graph2.txt' ],
    [ '2 graph3.txt', 'test2_graph3.txt' ],
];

foreach ($tests as $test) {
    exec('..\\GraphTasks.exe ' . $test[0] . ' > _test_.tmp');
    check('_test_.tmp', 'res/' . $test[1]);
    unlink('_test_.tmp');
}

function check($file1, $file2)
{
    $contents1 = file_get_contents($file1);
    $contents2 = file_get_contents($file2);

    if (trim($contents1) == trim($contents2)) {
        echo '.';
    } else {
        echo 'E';
    }
}
