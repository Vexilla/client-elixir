

defmodule VexillaClientElixir do
  @moduledoc """
  Documentation for `VexillaClientElixir`.
  """


  @doc """
  Create a client with a base url and environment name

  ## Examples

    iex> VexillaClientElixir.create_config("https://somewhere-on-the-internet", "staging")
    %{
      base_url: "https://somewhere-on-the-internet",
      environment: "staging"
    }

  """
  def create_config(base_url, environment)
    when is_binary(base_url) and is_binary(environment) do
      %{
        base_url: base_url,
        environment: environment
      }
  end


  @doc """
  Fetch the flags and parse, returning the appropriate flags for the environment

  ## Examples

    iex> VexillaClientElixir.get_flags(%{base_url: "https://streamparrot-feature-flags.s3.amazonaws.com",environment: "staging"}, "features")
    %{
      "untagged" => %{
        "billing" => %{
          "type" => "toggle",
          "value" => false
        }
      },
      "features" => %{
        "billing" => %{
          "type" => "toggle",
          "value" => false
        }
      }
    }

  """
  def get_flags(config, fileName) do
    HTTPoison.start()
    flags_response = HTTPoison.get!("#{config.base_url}/#{fileName}.json")

    flags_response_parsed = Jason.decode!(flags_response.body)

    flags_response_parsed["environments"][config.environment]
  end


  @doc """
  Checks if the flag allows this feature to be used

  ## Examples

    iex> VexillaClientElixir.should?(%{"untagged" => %{"billing" => %{"type" => "toggle","value" => false}}}, "billing")
    false

  """
  def should?(flags, flagName) do
    feature = flags["untagged"][flagName]
    inner_should?(feature)
  end

  @doc """
  Checks if the flag allows this feature to be used

  ## Examples

    iex> VexillaClientElixir.should?(%{"features" => %{"billing" => %{"type" => "toggle","value" => false}}}, "billing", "features")
    false

  """
  def should?(flags, flagName, groupName) do
    feature = flags[groupName][flagName]
    inner_should?(feature)
  end

  defp inner_should?(feature) do
    case feature["type"] do
      "toggle" -> feature["value"]
      "gradual" -> feature["value"]
      # _ -> IO.inspect()
    end
  end

end
