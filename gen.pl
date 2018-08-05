use strict;
use Data::Dumper;

sub read_line
{
	my $file = @_[0];
	my $line_number = @_[1];

	open my $fh, '<', $file or die "$file: $!";
	my $line;
	while (<$fh>)
    {
	    if ($. == $line_number)
        {
		    $line = $_;
		    last;
	    }
	}

	return $line;
}

sub clean_line
{
	my $line = @_[0];
	$line =~ s/\s*\/*[-\*]{2,}\s*//g;
	$line =~ s/\R\z//;
	return $line;
}

my $num_args = $#ARGV + 1;
if ($num_args < 1)
{
	print "\nUsage: gen [FILES]\n";
	exit;
}

my %files;
foreach my $argnum (0 .. $#ARGV)
{
	my $result = `commentective -s $ARGV[$argnum]` or die "Could not find commentective";
	my @result = split "\n", $result;

	foreach (@result)
    {
		my ($line_number) = ($_ =~ m/\|(\d+)/);
		my ($file) = ($_ =~ m/(.+)\|/);
		# Create hashmap where the key is the file name and the value an array of lines
		push(@{$files{$file}}, $line_number + 0);
	}
}

my %file_groups;
for my $file (keys %files)
{
	my @line_numbers = @{$files{$file}};
	my $group_num = 0;
	my $last_number = $line_numbers[0] - 1;
	while (my $line_number = <@line_numbers>)
    {
		if ($line_number != $last_number + 1)
        {
			$group_num = $group_num + 1;
		}
		push(@{$file_groups{"$file|$group_num"}}, $line_number);
		$last_number = $line_number;
	}
}

for my $file_with_number (keys %file_groups)
{
	my ($file) = ($file_with_number =~ m/(.+)\|/);

	# Filter the groups not matching the API documentation
	my @line_numbers = @{$file_groups{$file_with_number}};

	my @lines;
	foreach(@line_numbers)
    {
		push(@lines, read_line($file, $_));
	}

	if (@lines[0] !~ m/\s*---\s*\w*[\.:]|\/\*{3}\s*\w*[\.:]/)
    {
		# Line doesn't start with the required --- if Lua or /*** if C++
		next;
	}

	my $function_name = clean_line(@lines[0]);

	my ($file_to_open) = ($function_name =~ m/(.*)\./);
	$file_to_open = "$file_to_open.md";
	open(my $fh, '>>', $file_to_open) or die "Could not open file '$file_to_open' $!";

	my $in = 0;
	my $index = -1;
	foreach(@lines)
    {
		$index = $index + 1;

		my $line = clean_line($_);
		# Header
		if ($index == 0)
        {
			print $fh "### `$function_name`\n\n";
			next;
		}

		# Description
		if ($line !~ m/^@/)
        {
			# This is a description, it doesn't start with @
			if ($index == 1)
            {
				# This is the main description, don't give it extra formatting.
				print $fh "$line\n";
			}
            else
            {
				print $fh "_$line\_\n";
			}
			next;
		}

		# Params
		if ($line =~ m/^\@param/)
        {
			my ($stripped) = ($line =~ m/^\S+:(.*)/);

			if ($in != 1)
            {
				# Not in the function yet, print the header
				$in = 1;
				print $fh "\n#### Parameters\n\n";
			}
			my ($param_type) = ($stripped =~ m/^(\S+)/);
			my ($param_name) = ($stripped =~ m/^\S+\s+(\S+)/);
			my ($param_description) = ($stripped =~ m/^\S+\s+\S+\s+(.+)/);

			if ($param_description eq "")
            {
				print $fh "* `$param_name`: (_`$param_type`_)\n";
			}
            else
            {
				print $fh "* `$param_name`: (_`$param_type`_) $param_description\n";
			}
			next;
		}

		# Return
		if ($line =~ m/^\@return/)
        {
			my ($stripped) = ($line =~ m/^\S+:(.*)/);

			if ($in != 2)
            {
				# Not in the function yet, print the header
				$in = 2;
				print $fh "\n#### Return\n\n";
			}
			my ($param_type) = ($stripped =~ m/^(\S+)/);
			my ($param_description) = ($stripped =~ m/^\S+\s+(.+)/);

			if ($param_description eq "")
            {
				print $fh "* (`$param_type`)\n";
			}
            else
            {
				print $fh "* (`$param_type`) $param_description\n";
			}
			next;
		}

		print "$line\n";
	}

	print $fh "\n";
	close $fh;
}
