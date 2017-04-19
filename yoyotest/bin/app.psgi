#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use Yoyotest;


Yoyotest->to_app;

use Plack::Builder;

builder {
    enable 'Deflater';
    Yoyotest->to_app;
}



=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use yoyotest;
use Plack::Builder;

builder {
    enable 'Deflater';
    yoyotest->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use yoyotest;
use yoyotest_admin;

builder {
    mount '/'      => yoyotest->to_app;
    mount '/admin'      => yoyotest_admin->to_app;
}

=end comment

=cut

