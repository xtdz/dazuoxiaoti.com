<?php
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = 'pass';
$dbname = 'vjoin_dev';
$table = 'surveys';
$file = "surveys";

$conn = mysql_connect($dbhost, $dbuser, $dbpass) or die ('Error connecting to mysql');
mysql_select_db($dbname);

$fp = fopen($file, "r");
$data = fread($fp, filesize($file));
fclose($fp);
$output = explode("\n", $data);
$myFile = "output.txt";
$fh = fopen($myFile, 'w') or die("can't open file");

foreach($output as $var) {
  $tmp = explode("\t", $var);
	$title = $tmp[0];
	$c1 = $tmp[1];
	$c2 = $tmp[2];
	$c3 = $tmp[3];
	$c4 = $tmp[4];
	if ($tmp[1]) {
	$sql = "INSERT INTO $table SET title='$title', choice1='$c1', choice2='$c2', choice3='$c3', choice4='$c4', count1=0, count2=0, count3=0, count4=0, created_at=now(), updated_at=now()";
	fwrite($fh, $sql);
	echo $sql;
	mysql_query($sql);
	}
}
fclose($fh);
mysql_close($conn);
?>
