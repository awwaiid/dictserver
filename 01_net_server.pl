#!/usr/bin/perl

use CGI;

# Read the dictionary into the word hash
my %words = map { $_, 1 } split(/\n/, `cat dict/dict.txt`);

# Instantiate and start the web server
use base qw(Net::Server::HTTP);
__PACKAGE__->run( port => 8338 );

sub process_http_request {
        # Make a CGI object for the request
        my $cgi = CGI->new;

        # Get the word from the user
        my $word = $cgi->param( "word" );
        $word =~ s/\W//g;

        # And the callback name
        my $callback = $cgi->param( "callback" );
        $callback =~ s/\W//g;

        print "Content-type: text/javascript\n\n";

        if ( $word && $callback ) {
                # Dump back the results in a JSONP format
                print $callback . '({"word":"' . $word .
                        '","pass":' . (defined $words{ $word } ?
                                'true' : 'false') . '})';
        }
}

