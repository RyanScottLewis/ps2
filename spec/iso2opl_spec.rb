require 'spec_helper'

class Dummy
  undef :to_s
end

describe PS2 do
  
  describe '.rename' do
    
    context '(path)' do
      
      context 'When an Object that does not respond to #to_s is given' do
        
        it 'should raise PS2::InvalidPath' do
          expect { PS2.rename(Dummy.new) }.to raise_error(PS2::InvalidPath)
        end
        
      end
      
      context 'When a path that does not exist is given' do
        
        it 'should raise PS2::PathNotFoundError' do
          expect { PS2.rename('/non_existant_file.iso') }.to raise_error(PS2::PathNotFoundError)
        end
        
      end
      
      context 'When a directory is given' do
        
        it 'should raise PS2::NotFileError' do
          create_dir('/directory') do |path|
            expect { PS2.rename(path) }.to raise_error(PS2::NotFileError)
          end
        end
        
      end
      
      context 'When a file that exists but does not have the .iso extension' do
        
        it 'should raise PS2::NotISOFileError' do
          create_file('existing_file.rb') do |path|
            expect { PS2.rename(path) }.to raise_error(PS2::NotISOFileError)
          end
        end
        
      end
      
      context 'When an existing ISO file is given' do
        
        it 'should attempt to convert the path to the OPL name and parse the game code from the ISO' do
          path = mock
          new_path = Pathname.new('/foo/bar/TEST_123.45.My Game.iso')
          ext = mock
          path.stub(:to_s).and_return(path)
          path.stub(:exist?).and_return(true)
          path.stub(:file?).and_return(true)
          path.stub(:extname).and_return(ext)
          ext.stub(:downcase).and_return('.iso')
          
          path.stub(:is_a?).and_return(true)
          path.should_receive(:to_opl_name).and_return('My Game')
          path.should_receive(:parse_opl_code).and_return('TEST_123.45')
          path.should_receive(:dirname).and_return( Pathname.new('/foo/bar') )
          path.should_receive(:rename).with(new_path.to_s)
          
          PS2.rename(path.to_s).should == new_path
        end
        
      end
      
    end
    
    context '(path, options)' do
      
      context 'When an existing ISO file is given' do
        
        context 'and the :name option is given' do
          
          it 'should use the name given and parse the game code from the ISO' do
            path = mock
            new_path = Pathname.new('/foo/bar/TEST_123.45.Awesome Game - Part 2.iso')
            ext = mock
            path.stub(:to_s).and_return(path)
            path.stub(:exist?).and_return(true)
            path.stub(:file?).and_return(true)
            path.stub(:extname).and_return(ext)
            ext.stub(:downcase).and_return('.iso')
            
            path.stub(:is_a?).and_return(true)
            path.should_not_receive(:to_opl_name)
            path.should_receive(:parse_opl_code).and_return('TEST_123.45')
            path.should_receive(:dirname).and_return( Pathname.new('/foo/bar') )
            path.should_receive(:rename).with(new_path.to_s)
            
            PS2.rename(path.to_s, name: 'Awesome Game - Part 2').should == new_path
          end
          
        end
        
        context 'and the :code option is given' do
          
          it 'should attempt to convert the path to the OPL name and and use the game code given' do
            path = mock
            new_path = Pathname.new('/foo/bar/FAKE_999.99.My Game.iso')
            ext = mock
            path.stub(:to_s).and_return(path)
            path.stub(:exist?).and_return(true)
            path.stub(:file?).and_return(true)
            path.stub(:extname).and_return(ext)
            ext.stub(:downcase).and_return('.iso')
            
            path.stub(:is_a?).and_return(true)
            path.should_receive(:to_opl_name).and_return('My Game')
            path.should_not_receive(:parse_opl_code)
            path.should_receive(:dirname).and_return( Pathname.new('/foo/bar') )
            path.should_receive(:rename).with(new_path.to_s)
            
            PS2.rename(path.to_s, code: 'FAKE_999.99').should == new_path
          end
          
        end
        
        context 'and both the :name and :code options are given' do
          
          it 'should attempt to convert the path to the OPL name and and use the game code given' do
            path = mock
            new_path = Pathname.new('/foo/bar/FAKE_999.99.Awesome Game - Part 2.iso')
            ext = mock
            path.stub(:to_s).and_return(path)
            path.stub(:exist?).and_return(true)
            path.stub(:file?).and_return(true)
            path.stub(:extname).and_return(ext)
            ext.stub(:downcase).and_return('.iso')
            
            path.stub(:is_a?).and_return(true)
            path.should_not_receive(:to_opl_name)
            path.should_not_receive(:parse_opl_code)
            path.should_receive(:dirname).and_return( Pathname.new('/foo/bar') )
            path.should_receive(:rename).with(new_path.to_s)
            
            PS2.rename(path.to_s, code: 'FAKE_999.99', name: 'Awesome Game - Part 2').should == new_path
          end
          
        end
        
      end
      
    end
    
    context '(path, &blk)' do
      
      context 'When an existing ISO file is given' do
        
        context 'when a block is given' do
          
          it 'should pass the parsed code and name to the block variables' do
            path = mock
            new_path = Pathname.new('/foo/bar/TEST_123.45.My Game.iso')
            ext = mock
            path.stub(:to_s).and_return(path)
            path.stub(:exist?).and_return(true)
            path.stub(:file?).and_return(true)
            path.stub(:extname).and_return(ext)
            ext.stub(:downcase).and_return('.iso')
            
            path.stub(:is_a?).and_return(true)
            path.should_receive(:to_opl_name).and_return('My Game')
            path.should_receive(:parse_opl_code).and_return('TEST_123.45')
            path.should_receive(:dirname).and_return( Pathname.new('/foo/bar') )
            path.should_receive(:rename).with(new_path.to_s)
            
            PS2.rename(path.to_s) { |code, name|
              code.should == 'TEST_123.45'
              name.should == 'My Game'
              
              "#{code}.#{name}.iso"
            }.should == new_path
          end
          
        end
        
      end
      
    end
    
    context '(path, options, &blk)' do
      
      context 'When an existing ISO file is given' do
        
        context 'when a block is given with options' do
          
          it 'should pass the parsed code and name to the block variables' do
            path = mock
            new_path = Pathname.new('/foo/bar/TEST_123.45.My Game.iso')
            ext = mock
            path.stub(:to_s).and_return(path)
            path.stub(:exist?).and_return(true)
            path.stub(:file?).and_return(true)
            path.stub(:extname).and_return(ext)
            ext.stub(:downcase).and_return('.iso')
            
            path.stub(:is_a?).and_return(true)
            path.should_not_receive(:to_opl_name)
            path.should_not_receive(:parse_opl_code)
            path.should_receive(:dirname).and_return( Pathname.new('/foo/bar') )
            path.should_receive(:rename).with(new_path.dirname.join('foo.bar.iso').to_s)
            
            PS2.rename(path.to_s, code: 'foo', name: 'bar') { |code, name|
              code.should == 'foo'
              name.should == 'bar'
              
              "#{code}.#{name}.iso"
            }.should == new_path.dirname.join('foo.bar.iso')
          end
            
        end
        
      end
      
    end
    
  end
  
  describe '.scan' do
    
    context '(path)' do
      
      context 'When an Object that does not respond to #to_s is given' do
        
        it 'should raise PS2::InvalidPath' do
          expect { PS2.scan(Dummy.new) }.to raise_error(PS2::InvalidPath)
        end
        
      end
      
      context 'When a path that does not exist is given' do
        
        it 'should raise PS2::PathNotFoundError' do
          expect { PS2.scan('/non_existant_file.iso') }.to raise_error(PS2::PathNotFoundError)
        end
        
      end
      
      context 'When a file is given' do
        
        it 'should raise PS2::NotDirectoryError' do
          create_file('not_dir.rb') do |path|
            expect { PS2.scan(path) }.to raise_error(PS2::NotDirectoryError)
          end
        end
        
        context 'When a directory that exists but does not have any files with the .iso extension' do
          
          it 'should return an empty Hash' do
            dir = create_dir('/my_dir')
            files = []
            files << create_file('/my_dir/test.rb')
            files << create_file('/my_dir/test.js')
            files << create_file('/my_dir/test.css')
            files << create_file('/my_dir/test.html')
            
            PS2.scan(dir).should == {}
            
            files.each { |path| delete_file(path) }
            delete_dir(dir)
          end
          
        end
        
        context 'When a directory that exists that does have files with the .iso extension' do
          
          context 'and no errors were thrown' do
            
            it 'should return a Hash with the old path as the key and the new path as the value' do
              dir = create_dir('/my_dir')
              files = []
              files << create_file('/my_dir/1.iso')
              files << create_file('/my_dir/2.iso')
              files << create_file('/my_dir/3.iso')
              
              paths = files.collect { |path| Pathname.new(path) }
              
              PS2.stub(:rename).and_return('TEST_VALUE')
              
              PS2.scan(dir).should == paths.each_with_object({}) { |path, memo| memo[path] = 'TEST_VALUE' }
              
              files.each { |path| delete_file(path) }
              delete_dir(dir)
            end
            
          end
          
          context 'and errors were thrown' do
            
            it 'should return a Hash with the old path as the key and the error thrown as the value' do
              dir = create_dir('/my_dir')
              files = []
              files << create_file('/my_dir/1.iso')
              files << create_file('/my_dir/2.iso')
              files << create_file('/my_dir/3.iso')
              
              paths = files.collect { |path| Pathname.new(path) }
              error = StandardError.new
              
              PS2.stub(:rename).and_return(error)
              
              PS2.scan(dir).should == paths.each_with_object({}) { |path, memo| memo[path] = 'TEST_VALUE' }
              
              files.each { |path| delete_file(path) }
              delete_dir(dir)
            end
            
          end
          
        end
        
      end
      
    end
    
    context '(path, options)' do
      
      
      
    end
    
    context '(path, &blk)' do
      
      
      
    end
    
    context '(path, options, &blk)' do
      
      
      
    end
    
  end
  
end
