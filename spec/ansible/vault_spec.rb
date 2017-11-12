RSpec.describe Ansible::Vault do
  it "has a version number" do
    expect(Ansible::Vault::VERSION).not_to be nil
  end

  def ansible_is_available?
    `which ansible-vault`.length > 1
  end

  current_dir = Pathname.new(__FILE__).dirname
  password_file = current_dir + "key.txt"

  context "with ANSIBLE_VAULT_PASSWORD_FILE set" do
    before(:all) { ENV["ANSIBLE_VAULT_PASSWORD_FILE"] = password_file.to_s }
    after(:all) { ENV.delete("ANSIBLE_VAULT_PASSWORD_FILE") }

    describe "#decrypt" do
      let(:plain_file) { current_dir + "plain.yml" }
      let(:encrypted_file) { current_dir + "encrypted.yml" }
      let(:original) { File.read(plain_file) }

      it "decrypts without exceptions" do
        skip "ansible is not available" unless ansible_is_available?
        expect { Ansible::Vault.decrypt(file: encrypted_file) }.not_to raise_exception
      end

      it "decrypts encrypted_file and the content is identical" do
        skip "ansible is not available" unless ansible_is_available?
        expect(Ansible::Vault.decrypt(file: encrypted_file)).to eq original
      end
    end

    describe "#decrypt_as_yaml" do
      let(:plain_file) { current_dir + "plain.yml" }
      let(:encrypted_file) { current_dir + "encrypted.yml" }
      let(:original) { File.read(plain_file) }
      let(:original_yaml) { YAML.safe_load(original) }

      it "decrypts without exceptions" do
        skip "ansible is not available" unless ansible_is_available?
        expect { Ansible::Vault.decrypt_as_yaml(file: encrypted_file) }.not_to raise_exception
      end

      it "decrypts encrypted_file as YAML and the content is identical" do
        skip "ansible is not available" unless ansible_is_available?
        expect(Ansible::Vault.decrypt_as_yaml(file: encrypted_file)).to eq original_yaml
      end
    end
  end
  context "with ANSIBLE_VAULT_PASSWORD_FILE set" do
    before(:all) { ENV.delete("ANSIBLE_VAULT_PASSWORD_FILE") }

    describe "#decrypt" do
      let(:plain_file) { current_dir + "plain.yml" }
      let(:encrypted_file) { current_dir + "encrypted.yml" }
      let(:original) { File.read(plain_file) }

      it "raises exception" do
        skip "ansible is not available" unless ansible_is_available?
        expect { Ansible::Vault.decrypt(file: encrypted_file) }.to raise_exception PasswordNotSetError
      end
    end

    describe "#decrypt_as_yaml" do
      let(:plain_file) { current_dir + "plain.yml" }
      let(:encrypted_file) { current_dir + "encrypted.yml" }
      let(:original) { File.read(plain_file) }
      let(:original_yaml) { YAML.safe_load(original) }

      it "raises exception" do
        skip "ansible is not available" unless ansible_is_available?
        expect { Ansible::Vault.decrypt_as_yaml(file: encrypted_file) }.to raise_exception PasswordNotSetError
      end
    end
  end
end
