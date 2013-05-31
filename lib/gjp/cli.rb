# encoding: UTF-8

require "clamp"

class MainCommand < Clamp::Command
  subcommand "get-pom", "Retrieves a pom file for an archive or project directory" do
    parameter "PATH", "project directory or jar file path"
    option ["-v", "--verbose"], :flag, "verbose output"
    option ["--very-verbose"], :flag, "very verbose output"
    option ["--very-very-verbose"], :flag, "very very verbose output"

    def execute
      begin
        init_logger       
        puts PomGetter.get_pom(path)
      rescue Zip::ZipError
        $stderr.puts "#{path} does not seem to be a valid jar archive, skipping"
      rescue TypeError
        $stderr.puts "#{path} seems to be a valid jar archive but is corrupt, skipping"
      rescue RestClient::ResourceNotFound
        $stderr.puts "Got an error while looking for #{path} in search.maven.org" 
      end
    end
  end
    
  subcommand "get-source-address", "Retrieves a project's source Internet address" do
    parameter "PATH", "project's pom file path"
    option ["-v", "--verbose"], :flag, "verbose output"
    option ["--very-verbose"], :flag, "very verbose output"
    option ["--very-very-verbose"], :flag, "very very verbose output"

    def execute
      init_logger
      puts SourceAddressGetter.get_source_address(path)
    end    
  end
  
  subcommand "get-source", "Retrieves a project's source code directory" do
    parameter "ADDRESS", "project's source SCM address"
    parameter "PATH", "project's pom file path"
    option ["-v", "--verbose"], :flag, "verbose output"
    option ["--very-verbose"], :flag, "very verbose output"
    option ["--very-very-verbose"], :flag, "very very verbose output"

    def execute
      init_logger
      puts SourceGetter.get_source(address, path, ".")
    end    
  end
end
