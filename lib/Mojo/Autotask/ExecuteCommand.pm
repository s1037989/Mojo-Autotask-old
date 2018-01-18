package Mojo::Autotask::ExecuteCommand;
use Mojo::Base -base;

has _open_ticket_detail => 'https://ww5.autotask.net/Autotask/AutotaskExtend/ExecuteCommand.aspx?Code=OpenTicketDetail&TicketNumber=%s&AccountID=%s';

sub open_ticket_detail { sprintf shift->_open_ticket_detail, _a2h(@_) }

sub _a2h {
  local %_ = @_;
  map { $_ => $_{$_} } keys %_;
}

1;
