package Three;

package Three::Bar;
sub new {
    my ($class, $args) = @_;
    $args ||= {};
    bless { %{ $args } }, $class;
}
sub three { shift->{three} }

package ThreeBar;
sub three {1}

1;
