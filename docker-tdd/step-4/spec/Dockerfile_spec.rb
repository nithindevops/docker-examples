# A Stub spec for our Dockerfile.

require "serverspec"
require "docker"

# We describe the behavior of our Dockerfile.
describe "Dockerfile" do
    
    # The "Before" block executes actions before executing spec.
    # Within this block we build our Docker image using the Docker API for Ruby.
    # We create an @image object that can be used in our validation steps.

    before(:all) do
        @image = Docker::Image.build_from_dir('.')
        @image.tag(repo: 'savishy/tomcat-petclinic-tdd', tag: 'latest')
    
        set :os, family: :alpine
        set :backend, :docker
        set :docker_image, @image.id
    end

    def os_release
        command("cat /etc/os-release").stdout
    end

    def java_version
        command('/usr/bin/java -version').stderr
    end

    def app_directory
        command('ls /app').stderr
    end

    def app_file
        command('ls /app/petclinic.jar').stderr
    end

    # We have created stub tests based on our specs.
    # For now we are marking these tests pending.

    it "should have a maintainer label" do
        expect(@image.json["Config"]["Labels"].has_key?("maintainer"))
    end

    # This is a test that will pass because its
    # been implemented in the Dockerfile.
  
    it "should have alpine OS" do
        expect(os_release).to contain("alpine").and contain("3.7.0")
    end

    it "should have jdk 8" do
        expect(java_version).to contain("1.8.0_151")
    end

    it "should have /app directory" do
        expect(app_directory).to_not contain('No such file or directory')
    end
  
    it "should have petclinic.jar in /app directory" do
        expect(app_file).to_not contain('No such file or directory')
    end
  
end