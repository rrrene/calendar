defmodule Kalends.TimeZoneData do
  # make sure TzPeriodBuilder is compiled before compiling
  require Kalends.TzPeriodBuilder

  # For each canonical zone, calculate periods
  Enum.each Kalends.TzData.zone_list, fn (zone_name) ->
    def periods(unquote(zone_name)) do
      {:ok, unquote(Macro.escape(Kalends.TzPeriodBuilder.calc_periods(zone_name)))}
    end
  end

  # For each linked zone, call canonical zone
  Enum.each Kalends.TzData.links, fn {alias_name, canonical_name} ->
    def periods(unquote(alias_name)) do
      periods(unquote(canonical_name))
    end
  end

  # if a periods for a zone has not been defined at this point,
  # the zone name does not exist
  def periods(_zone_name), do: {:error, :not_found}

  # Provide lists of zone- and link-names
  # Note that the function names are different from TzData!
  # The term "alias" is used instead of "link"
  def zone_list, do: unquote(Macro.escape(Kalends.TzData.zone_and_link_list))
  def canonical_zone_list, do: unquote(Macro.escape(Kalends.TzData.zone_list))
  def zone_alias_list, do: unquote(Macro.escape(Kalends.TzData.link_list))

  def zone_exists?(name), do: Enum.member?(zone_list, name)
  def canonical_zone?(name), do: Enum.member?(canonical_zone_list, name)
  def zone_alias?(name), do: Enum.member?(zone_alias_list, name)

  # Provide map of links
  def links, do: unquote(Macro.escape(Kalends.TzData.links))
end
