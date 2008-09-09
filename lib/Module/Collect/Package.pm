package Module::Collect::Package;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw(package path));

sub new {
    my ($class, @args) = @_;
    if (ref $class) {
        return $class->{package}->new(@args);
    } else {
        my $self = $class->SUPER::new(@args);
        bless $self, $class;
        return $self;
    }
}

sub require {
    my ($self) = shift;
    eval {require $self->{path}} or die $@;
}

1;
