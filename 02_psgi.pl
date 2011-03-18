#!/usr/bin/perl

# starman --preload-app 02_psgi.pl

use Plack::Request;

# Read the dictionary into the word hash
my %words = map { $_, 1 } split(/\n/, `cat dict/dict.txt`);

return sub {
      my $env = shift; # PSGI env
      my $req = Plack::Request->new($env);

        # Get the word from the user
        my $word = $req->param( "word" );
        $word =~ s/\W//g;

        # And the callback name
        my $callback = $req->param( "callback" );
        $callback =~ s/\W//g;

        if($word && $callback) {
            return [
                200,
                [ 'Content-Type' => 'text/javascript'],
                [ 
                    $callback . '({"word":"' . $word .
                              '","pass":' . (defined $words{ $word } ?
                                      'true' : 'false') . '})'
                ]
            ];
        }
}

