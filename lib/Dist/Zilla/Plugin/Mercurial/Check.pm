package Dist::Zilla::Plugin::Mercurial::Check;
{
  $Dist::Zilla::Plugin::Mercurial::Check::VERSION = '0.02';
}

use strict;
use warnings;

use Moose;

with 'Dist::Zilla::Role::BeforeRelease';

sub before_release {
    my $self = shift;

    my $branch = `hg branch`;
    chomp $branch;

    if ( my @output = `hg status` ) {
        my $errmsg
            = "This branch ($branch) has some files that are not yet committed:\n"
            . join q{}, map {"\t$_"} @output;
        $self->log_fatal($errmsg);
    }

    $self->log("This branch ($branch) is in a clean state");
}

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Check for modified/removed/unknown files

__END__

=pod

=head1 NAME

Dist::Zilla::Plugin::Mercurial::Check - Check for modified/removed/unknown files

=head1 VERSION

version 0.02

=head1 SYNOPSIS

In your F<dist.ini>:

  [Mercurial::Check]

=head1 DESCRIPTION

This plugin checks that your working copy is in a clean state before
releasing. This means that C<hg status> returns no output.

=for Pod::Coverage before_release

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Dave Rolsky.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
