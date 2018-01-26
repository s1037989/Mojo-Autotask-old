package Mojo::Autotask::ExecuteCommand;
use Mojo::Base -base;

use Mojo::URL;
use Mojo::Util 'camelize';
use Mojolicious::Validator;

use Carp;
use Scalar::Util;

has baseurl => sub { Mojo::URL->new('https://ww5.autotask.net/AutotaskAutotaskExtend/ExecuteCommand.aspx') };

sub AUTOLOAD {
  my ($self, @args) = @_;

  my ($package, $method) = our $AUTOLOAD =~ /^(.+)::(.+)$/;
  Carp::croak "Undefined subroutine &${package}::$method called"
    unless Scalar::Util::blessed $self && $self->isa(__PACKAGE__);

  my $validator  = Mojolicious::Validator->new;
  my $validation = $validator->validation;

  $validation->input({Code => camelize($method), @args});
  $validation->optional('TicketID')->is_valid
    || $validation->optional('TicketNumber')->is_valid
    || $validation->optional('GlobalTaskID')->is_valid
    if $validation->required('Code')->like(qr/OpenTicketDetail/);
  # NewTicket: Phone, AccountID, AccountName, GlobalTaskID, InstalledProductID
  # OpenTicketDetail: TicketID, TicketNumber, GlobalTaskID
  # NewAccount:
  # OpenAccount: Phone, AccountID, AccountName
  # EditAccount: Phone, AccountiD
  # NewAccountNote: AccountID
  # NewContact: Phone, AccountID
  # EditContact: ContactID, Email, FirstName, LastName
  # OpenContact: Email, ContactID
  # NewInstalledProduct: Phone, AccountID
  # EditInstalledProduct: InstalledProductID
  # OpenTicketTime: TicketID
  # EditTimeEntry: WorkEntryID
  # OpenAppointment: AppointmentID
  # OpenContract: ContractID
  # IPDW: wizard
  # OpenKBArticle: ID
  # OpenOpportunity: OpportunityID
  # OpenProject: ProjectID
  # OpenSalesOrder: SalesOrderID
  # OpenServiceCall: ServiceCallID
  # OpenTaskDetail: TaskID
  # TimeOffRequest: ResourceID, ApproverID, Tier
  # OpenToDo: ToDoID
  # https://ww5.autotask.net/help/Content/AdminSetup/2ExtensionsIntegrations/APIs/ExecuteCommand/UsingExecuteCommandAPI.htm

  return $self->baseurl->query($validation->input);# unless $validation->has_error;
}

1;

=head1 NAME

Mojo::Autotask::ExecuteCommand - Mojo interface to the Autotask ExecuteCommand API

=cut
