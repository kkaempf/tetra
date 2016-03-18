# encoding: UTF-8

module Tetra
  # tetra dry-run
  class DryRunSubcommand < Tetra::Subcommand
    def execute
      checking_exceptions do
        project = Tetra::Project.new(".")

        if project.src_patched?
          puts "Changes detected in src/, please use:"
          puts " \"tetra patch\" to include those changes in the package as a patch file"
          puts " \"tetra change-sources\" to completely swap the source archive."
          puts "Dry run not started."
        else
          project.dry_run
          puts "Dry-run started in a new bash shell."
          puts "Build your project now, \"gradle\", \"mvn\" and \"ant\" are already bundled by tetra."
          puts "If the build succeedes end this dry run with ^D (Ctrl+D),"
          puts "if the build does not succeed use ^C^D to abort and undo any change"

          begin
            history = Tetra::Bash.new(project).bash
            project.finish(history)
            puts "Dry-run finished"
          rescue ExecutionFailed
            project.abort
            puts "Project reverted as before dry-run"
          end
        end
      end
    end
  end
end
