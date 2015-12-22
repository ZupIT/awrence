require File.expand_path(File.dirname(__FILE__) + '/../../test_awrence.rb')

using Awrence

describe "A Hash" do
  describe "with snake keys" do
    describe "which are JSON-style strings" do
      describe "in the simplest case" do
        before do
          @hash = { "first_key" => "fooBar" }
        end

        describe "non-destructive conversion to CamelCase" do
          before do
            @camelized = @hash.to_camel_keys({ first_upper: true })
          end

          it "camelizes the key" do
            assert_equal("FirstKey", @camelized.keys.first)
          end

          it "leaves the key as a string" do
            assert @camelized.keys.first.is_a? String
          end

          it "leaves the value untouched" do
            assert_equal(@camelized.values.first, "fooBar")
          end

          it "leaves the original hash untouched" do
            assert_equal(@hash.keys.first, "first_key")
          end

          it "camelize only the informed keys" do
            hash = { "first_key" => "fooBar", "second_key" => "barFoo" }
            camelized = hash.to_camel_keys({ only: ["first_key"] })

            assert_equal(camelized.keys[0], "firstKey")
            assert_equal(camelized.keys[1], "second_key")
          end
        end

        describe "non-destructive conversion to camelBack" do
          before do
            @camelized = @hash.to_camel_keys
          end

          it "camelizes the key" do
            assert_equal("firstKey", @camelized.keys.first)
          end

          it "leaves the key as a string" do
            assert @camelized.keys.first.is_a? String
          end

          it "leaves the value untouched" do
            assert_equal(@camelized.values.first, "fooBar")
          end

          it "leaves the original hash untouched" do
            assert_equal(@hash.keys.first, "first_key")
          end
        end
      end

      describe "containing an array of other hashes" do
        before do
          @hash = {
            "apple_type" => "Granny Smith",
            "vegetable_types" => [
              {"potato_type" => "Golden delicious"},
              {"other_tuber_type" => "peanut"},
                  {"peanut_names_and_spouses" => [
                    {"bill_the_peanut" => "sally_peanut"}, {"sammy_the_peanut" => "jill_peanut"}
                  ]}
              ]}
        end

        describe "non-destructive conversion to CamelCase" do
          before do
            @camelized = @hash.to_camel_keys({ first_upper: true })
          end

          it "recursively camelizes the keys on the top level of the hash" do
            assert @camelized.keys.include?("AppleType")
            assert @camelized.keys.include?("VegetableTypes")
          end

          it "leaves the values on the top level alone" do
            assert_equal(@camelized["AppleType"], "Granny Smith")
          end

          it "converts second-level keys" do
            assert @camelized["VegetableTypes"].first.has_key? "PotatoType"
          end

          it "leaves second-level values alone" do
            assert @camelized["VegetableTypes"].first.has_value? "Golden delicious"
          end

          it "converts third-level keys" do
            assert @camelized["VegetableTypes"].last["PeanutNamesAndSpouses"].first.has_key?("BillThePeanut")
            assert @camelized["VegetableTypes"].last["PeanutNamesAndSpouses"].last.has_key?("SammyThePeanut")
          end

          it "leaves third-level values alone" do
            assert_equal "sally_peanut", @camelized["VegetableTypes"].last["PeanutNamesAndSpouses"].first["BillThePeanut"]
            assert_equal "jill_peanut", @camelized["VegetableTypes"].last["PeanutNamesAndSpouses"].last["SammyThePeanut"]
          end
        end

        describe "non-destructive conversion to camelBack" do
          before do
            @camelized = @hash.to_camel_keys
          end

          it "recursively camelizes the keys on the top level of the hash" do
            assert @camelized.keys.include?("appleType")
            assert @camelized.keys.include?("vegetableTypes")
          end

          it "leaves the values on the top level alone" do
            assert_equal(@camelized["appleType"], "Granny Smith")
          end

          it "converts second-level keys" do
            assert @camelized["vegetableTypes"].first.has_key? "potatoType"
          end

          it "leaves second-level values alone" do
            assert @camelized["vegetableTypes"].first.has_value? "Golden delicious"
          end

          it "converts third-level keys" do
            assert @camelized["vegetableTypes"].last["peanutNamesAndSpouses"].first.has_key?("billThePeanut")
            assert @camelized["vegetableTypes"].last["peanutNamesAndSpouses"].last.has_key?("sammyThePeanut")
          end

          it "leaves third-level values alone" do
            assert_equal "sally_peanut", @camelized["vegetableTypes"].last["peanutNamesAndSpouses"].first["billThePeanut"]
            assert_equal "jill_peanut", @camelized["vegetableTypes"].last["peanutNamesAndSpouses"].last["sammyThePeanut"]
          end
        end

        describe "non-destructive conversion do camelBack ignoring slashes" do
          before do
            hash = { "my_first/key" => "fooBar" }
            @camelized = hash.to_camel_keys({ ignore_slash: true })
          end

          it "non-destructive conversion to camelBack ignore_slashes" do
            assert_equal "myFirst/key", @camelized.keys.first
          end
        end
      end
    end
  end

  describe "strings with spaces in them" do
    before do
      @hash = { "With Spaces" => "FooBar"}
    end

    describe "to_camel_keys" do
      it "doesn't get camelized" do
        @camelized = @hash.to_camel_keys
        assert_equal "With Spaces", @camelized.keys.first
      end
    end

    describe "to_camelback_keys" do
      it "doesn't get camelized" do
        @camelized = @hash.to_camel_keys
        assert_equal "With Spaces", @camelized.keys.first
      end
    end
  end
end
