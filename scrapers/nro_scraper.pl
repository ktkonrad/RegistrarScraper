#!/usr/bin/perl

# scrapes data from NRO webpage
# takes input from stdin
# outputs JSON to stdout
# JSON format is {$department:$coursenumber,...}
# some departments don't let you NRO any courses,
# in this case output will be $department:"all"




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
