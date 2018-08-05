# get all comment lines based on extension (c/c++: ///, lua: ---)

use strict;
use warnings;

use File::Basename;
use Data::Dumper;

sub parse_lua_file
{
    print "Parsing comments in lua file $_[0]\n";
    open(my $file, "<", "$_[0]") or die "Cannot open file $_[0]: $!";

    my %comments;
    my @group;
    my $group_no = 0;
    my $last = 0;

    while (<$file>)
    {
        if ($_ =~ /^\s*---\s.*$/)
        {
            #print "$.: $_";

            # new group
            if ($. != $last + 1)
            {
                if (scalar @group > 0)
                {
                    $comments{$group_no} = @group;
                }
                @group = ();
                $group_no++;
            }

            $last = $.;
            push @group, $_;
            print $_;
        }
    }    

    $comments{$group_no} = @group;

    close($file);
    print Dumper \%comments;
}

sub parse_c_file
{
    print "Parsing comments in C file $_[0]\n";

    open(FILE, "$_[0]");
    my @lines = <FILE>;
    close(FILE);
    my $content = join('', @lines);


}

my $fname = $ARGV[0] or die "Usage: perl parse.pl file\n";

unless (-f $fname)
{
    die "File $fname does not exist\n";
}

my ($name, $path, $suffix) = fileparse($fname, '\.[^\.]*');

if ($suffix =~ m/lua/i)
{
    parse_lua_file($fname);
}
elsif ($suffix =~ m/h|c|hpp|cpp/i)
{
    parse_c_file($fname);
}
else
{
    die "Input file should be a .lua file or .h/.c/.hpp/.cpp file";
}
