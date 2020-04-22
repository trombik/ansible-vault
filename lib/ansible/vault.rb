require "open3"
require "yaml"

class PasswordNotSetError < RuntimeError
end

module Ansible
  # helper mthods to decrypt files by ansible-vault
  module Vault
    @command = "ansible-vault view"

    # Decrypts encrypted file using ansible-vault
    #
    # @param [String] path to file to decrypt
    # @return [String] decrypted content of the file
    def self.decrypt(file:)
      raise_if_env_is_not_set
      o, e, s = run_command("#{@command} '#{file}'")
      raise "failed to decrypt file `#{file}`: `#{e}`" unless s.success?
      o
    end

    def self.run_command(cmd)
      Open3.capture3(cmd)
    end

    # Decrypts encrypted file as YAML using ansible-vault
    #
    # @param [String] path to file to decrypt
    # @return [Hash] decrypted content of the file in a Hash
    def self.decrypt_as_yaml(file:)
      YAML.safe_load(decrypt(file: file))
    end

    # Raises an exception when mandatory environment variable is not set
    def self.raise_if_env_is_not_set
      msg = "env variable `ANSIBLE_VAULT_PASSWORD_FILE` is not defined"
      raise PasswordNotSetError, msg unless ENV["ANSIBLE_VAULT_PASSWORD_FILE"]
    end
  end
end
