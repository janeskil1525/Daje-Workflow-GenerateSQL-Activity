package Daje::Workflow::GenerateSQL::Script::Index;
use Mojo::Base 'Daje::Workflow::GenerateSQL::Base::Common', -base, -signatures;

has 'tablename'  => "";

sub create_index($self) {
    my $sql = "";
    my $json = $self->json->{index};
    my $length = scalar @{$json};
    for (my $i = 0; $i < $length; $i++) {
        my $template = $self->templates->get_data_section('index');
        my $table_name = $self->tablename;
        $template =~ s/<<table>>/$table_name/ig;
        $template =~ s/<<type>>/@{$json}[$i]->{type}/ig;
        $template =~ s/<<fields>>/@{$json}[$i]->{fields}/ig;
        @{$json}[$i]->{fields} =~ s/,/_/ig;
        $template =~ s/<<field_names>>/@{$json}[$i]->{fields}/ig;
        $sql .= $template . "";
    }
    $self->set_sql($sql);
    return;
}

1;





#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME

Daje::Workflow::GenerateSQL::Script::Index


=head1 DESCRIPTION

pod generated by Pod::Autopod - keep this line to make pod updates possible ####################


=head1 REQUIRES

L<Mojo::Base> 


=head1 METHODS

=head2 create_index($self)

 create_index($self)();


=cut

