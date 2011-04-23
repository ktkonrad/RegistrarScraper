#!/usr/bin/perl

$flag = 0;

while (<>) {
    
    if (/NON-RECORDING OPTION OUT-OF-BOUNDS/) {
	$flag = 1;
    }
    if (/<p>([a-zA-Z ']+)((: All courses)|( [\d,\w\(\) ]+))<\/p>/ && $flag) {
	$output = $output . parseCourseNumList($1, $2);
    }
}

sub parseCourseNumList() {
    my ($dept, $nums) = @_;
    my $out = "";
    
    if ($nums =~ "All courses") {
	return "\"$dept\":\"all\",";
    }

    while ($nums =~ /(\d+)([\(\)\w\d, ]*)/) {
	$out = $out . "\"$dept\":$1,";
	$nums = $2;
    }
    return $out;
}

chop $output; # there's an extra comma on the end

print "{$output}\n";
