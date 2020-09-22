#!/usr/bin/perl

#Below is a basic subroutine for reading the input of a form.
#I didn't write it so I won't bother to explain it.
sub read_input
{
    local ($buffer, @pairs, $pair, $name, $value, %FORM);
    $ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
    if ($ENV{'REQUEST_METHOD'} eq "POST")
    {
		read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
    } else
    {
		$buffer = $ENV{'QUERY_STRING'};
    }
    @pairs = split(/&/, $buffer);
    foreach $pair (@pairs)
    {
		($name, $value) = split(/=/, $pair);
		$value =~ tr/+/ /;
		$value =~ s/%(..)/pack("C", hex($1))/eg;
		$FORM{$name} = $value;
    }
    %FORM;
}


%data = &read_input; #Make form input into an associative array
#The small database of correct answers
%meaning = ('1', 'Random Access Memory', '2', 'Compact Disk', '3', 'MPEG Layer 3', '4', 'Internet Explorer', '5', 'Netscape', '6', 'Internet Relay Chat', '7', 'America Online', '8', 'Internet Service Provider', '9', 'Hyper Text Transfer Protocol', '10', 'File Transfer Protocol', '11', 'Practical Extraction and Report Language', '12', 'Common Gateway Interface', '13', 'Visual Basic', '14', 'Active Server Pages', '15', 'JavaScript', '16', 'Questions and Answers', '17', 'Frequently Asked Questions', '18', 'Microsoft', '19', 'Macintosh', '20', 'Windows'); #small answers database 
$score = 0;
$a = 'a'; #Used to interchange "a" with "an" if needed

for ($i = 1; $i < 21; ++$i) 
{
	$ans = $data{"$i"};
	$correctans = $meaning{"$i"};  #Loops through all the input
	if ($ans eq $correctans)       #and compare the answers given
	{	                           #With the correct answers
		$score = $score + 5;       #If they match, add 5 to the score
	}
}

#Everything below just picks out a letter grade and message 
#based on the score
if ($score > 92)
{
	$letter = 'A';
	$msg = 'Excellent! 8-))';
	$color = '0000FF';
	$a = "an";
}
elsif ($score > 85 && $score < 93)
{
	$letter = 'B';
	$msg = 'Very Good! :-)';
	$color = '00FF00';
}
elsif ($score > 76 && $score < 86)
{
	$letter = 'C';
	$msg = 'Good! :)';
	$color = 'FFFF00';
}
elsif ($score > 69 && $score < 77)
{
	$letter = 'D';
	$msg = 'Need some work dude :|';
	$color = 'FF8000';
}
elsif ($score < 70)
{
	$letter = 'F';
	$msg = 'Uh. Have you been on long? :?(';
	$color = 'FF0000';
}

#Print output based on score.
print "Content-type: text/html\n\n";
print "<html>\n<title>Test Results</title>\n<body bgcolor=#FFFFFF text=000000 link=#0000FF>\n<table border=0>\n<tr>\n<td bgcolor=#$color>\n<font face=tahoma size=14>$msg</font>\n</td>\n</tr>\n<tr>\n<td>\n<font face=verdana size=2>You scored a total of $score percent! You got $a $letter!<br>\nIf you didn't do well, you can take the test again by going <a href=quiz.html>here</a>.<br>\nGood luck!</font></td>\n</tr>\n</table>\n</body>\n</html>\n\n";