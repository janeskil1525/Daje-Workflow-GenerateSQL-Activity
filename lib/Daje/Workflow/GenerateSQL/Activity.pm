package Daje::Workflow::GenerateSQL::Activity;
use Mojo::Base 'Daje::Workflow::Common::Activity::Base', -base, -signatures;


# NAME
# ====
##
# Daje::Workflow::GenerateSQL::Activity - It's new $module
#
# SYNOPSIS
# ========
##
#     use Daje::Workflow::GenerateSQL::Activity;
#
# DESCRIPTION
# ===========
##
# Daje::Workflow::GenerateSQL::Activity is ...
#
# LICENSE
# =======
#
# Copyright (C) janeskil1525.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# AUTHOR
# ======
#
# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>
#



our $VERSION = "0.01";

class Daje::GenerateSQL :isa(Daje::Generate::Base::Common) {

    use Daje::Generate::Input::Sql::ConfigManager;
    use Daje::Generate::Tools::FileChanged;
    use Daje::Generate::Sql::SqlManager;
    use Daje::Generate::Output::Sql::Table;
    use Daje::Generate::Tools::Datasections;
    use Config::Tiny;

    field $config_path :param :reader = "";
    field $config_manager;

    method process () {

        $self->_load_config();
        my $files_list = $self->_load_file_list();
        my $length = scalar @{$files_list};
        for (my $i = 0; $i < $length; $i++) {
            if ($self->_process_sql(@{$files_list}[$i])) {
                $config_manager->save_new_hash(@{$files_list}[$i]);
            }
        }

        return;
    }

    method _process_sql($file) {
        my $sql = "";
        try {
            my $table = $self->_load_table($file);
            $table->generate_table();
            $sql = $table->sql();
        } catch ($e) {
            die "Create sql failed '$e'";
        };

        try {
            Daje::Generate::Output::Sql::SqlManager->new(
                config => $self->config,
                file   => $file,
                sql    => $sql,
            )->save_file();
        } catch ($e) {
            die "Could not create output '$e'";
        };

        return 1;
    }

    method _load_table($file) {

        my $json = $config_manager->load_json($file);
        my $template = $self->_load_templates(
            'Daje::Generate::Templates::Sql',
            "table,foreign_key,index,section,file"
        );
        my $table;
        try {
            $table = Daje::Generate::Sql::SqlManager->new(
                template => $template,
                json     => $json,
            );
        } catch ($e) {
            die "process_sql failed '$e";
        };

        return $table;
    }



    method _load_file_list() {

        try {
            $config_manager = Daje::Generate::Input::Sql::ConfigManager->new(
                source_path => $self->config->{PATH}->{sql_source_dir},
                filetype    => '*.json'
            );
            $config_manager->load_changed_files();
        } catch ($e) {
            die "could not load changed files '$e";
        };

        return $config_manager->changed_files();
    }

}

1;
__END__


