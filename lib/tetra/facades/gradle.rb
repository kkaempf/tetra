# encoding: UTF-8

module Tetra
  # encapsulates tetra-specific Gradle commandline options
  class Gradle
    # returns a command line for running Gradle
    def self.commandline(project_path, gradle_path)
      full_path = if gradle_path
                    File.join(project_path, gradle_path, "gradle")
                  else
                    "gradle" # use system-provided executable
                  end
      home_path = File.join(project_path, "kit", "gradle")

      options = [
        "--gradle-user-home #{home_path}"
      ]

      "#{full_path} #{options.join(' ')}"
    end
  end
end
