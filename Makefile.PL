use 5.006;
use ExtUtils::MakeMaker;


WriteMakefile(
    'NAME'          => 'Geo::Hex',
    'VERSION_FROM'  => 'lib/Geo/Hex.pm', # finds $VERSION
    'PREREQ_PM' => {
        'Test::More'     => '0.96',
        'POSIX'          => 0,
        'Math::Round'    => 0,
        'Math::Trig'     => 0,
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Geo/Hex.pm', # retrieve abstract from module
       AUTHOR     => 'OHTSUKA Ko-hei <nene@kokogiko.net>') : ()),
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE' => 'perl', ) : () ),

    ( $ExtUtils::MakeMaker::VERSION >= 6.46 ? (
        'META_MERGE' => {
            resources => {
                repository  =>      'http://github.com/geohex/geohex-perl',
            },
        } ) : ()
    ),

);
