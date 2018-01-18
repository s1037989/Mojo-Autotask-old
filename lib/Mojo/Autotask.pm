package Mojo::Autotask;
use Mojo::Base -base;

use Carp 'croak';
use Mojo::Pg 4.0;
use Mojo::Log;
use Mojo::Date;
use Mojo::JSON 'j';
use Mojo::Util 'encode';
use Mojo::Loader 'load_class';
use Mojo::Collection;

use Scalar::Util 'weaken';

use Mojo::Autotask::WebService;
use Mojo::Autotask::ExecuteCommand;

has 'backend';
has log => sub { Mojo::Log->new };
has webservice => sub { Mojo::Autotask::WebService->new(@_) };
has execute => sub { Mojo::Autotask::Execute->new(@_) };

sub new {
  my $self = shift->SUPER::new(@_);

  my $backend = shift;
  my $class = 'Mojo::Autotask::Backend::' . $backend;
  my $e     = load_class $class;

  if ( $e ) {
    unshift @_, $backend;
  } else {
    $self->backend($class->new(@_));
    weaken $self->backend->autotask($self)->{autotask};
  }

  return $self;
}

1;
