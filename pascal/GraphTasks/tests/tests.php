<?php

$testTasks = [
    1 => [
        [ 'graph1.txt', 'test1_graph1.txt' ],
        [ 'graph2.txt', 'test1_graph2.txt' ],
        [ 'graph3.txt', 'test1_graph3.txt' ],
    ],
    2 => [
        [ 'graph1.txt', 'test2_graph1.txt' ],
        [ 'graph2.txt', 'test2_graph2.txt' ],
        [ 'graph3.txt', 'test2_graph3.txt' ],
    ],
    3 => [
        [ 'graph1.txt --from-point=1', 'test3_graph1_from1.txt' ],
        [ 'graph1.txt --from-point=2', 'test3_graph1_from2.txt' ],
        [ 'graph1.txt --from-point=3', 'test3_graph1_from3.txt' ],
        [ 'graph3.txt --from-point=1', 'test3_graph3_from1.txt' ],
        [ 'graph3.txt --from-point=2', 'test3_graph3_from2.txt' ],
        [ 'graph3.txt --from-point=3', 'test3_graph3_from3.txt' ],
    ],
    5 => [
        [ 'graph1.txt --from-point=1', 'test5_graph1_from1.txt' ],
        [ 'graph1.txt --from-point=2', 'test5_graph1_from2.txt' ],
        [ 'graph1.txt --from-point=3', 'test5_graph1_from3.txt' ],
        [ 'graph1.txt --from-point=4', 'test5_graph1_from4.txt' ],
        [ 'graph1.txt --from-point=5', 'test5_graph1_from5.txt' ],
        [ 'graph1.txt --from-point=6', 'test5_graph1_from6.txt' ],
        [ 'graph1.txt --from-point=7', 'test5_graph1_from7.txt' ],
        [ 'graph3.txt --from-point=1', 'test5_graph3_from1.txt' ],
        [ 'graph3.txt --from-point=2', 'test5_graph3_from2.txt' ],
        [ 'graph3.txt --from-point=3', 'test5_graph3_from3.txt' ],
        [ 'graph3.txt --from-point=4', 'test5_graph3_from4.txt' ],
        [ 'graph3.txt --from-point=9', 'test5_graph3_from9.txt' ],
        [ 'graph3.txt --from-point=10', 'test5_graph3_from10.txt' ],
    ],
    6 => [
        [ 'graph1.txt', 'test6_graph1.txt' ],
        [ 'graph2.txt', 'test6_graph2.txt' ],
        [ 'graph3.txt', 'test6_graph3.txt' ],
    ],
];

foreach ($testTasks as $task => $tests) {
    echo "Task{$task}\n";
    $executable = strtoupper(substr(PHP_OS, 0, 3)) === 'WIN' ? '..\\GraphTasks.exe ' : '../GraphTasks';
    foreach ($tests as $test) {
        exec("{$executable} {$task} {$test[0]} > _test_.tmp");
        check('_test_.tmp', 'res/' . $test[1]);
        unlink('_test_.tmp');
    }
    echo "\n";
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
