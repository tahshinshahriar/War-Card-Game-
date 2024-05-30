defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """

  def deal(shuf) do
    # Player1 and Player2 are refered as p1 and p2 respectively
    p1 = []
    p2 = []
    play_table = []
    # array's reversed to have the cards other way around (bottom -> top)
    # Replacing 1's with 14's to compare the cards easily
    pile = shuf |> Enum.reverse() |> replace_aces()

    # Dealing the cards between two players one by one
    {p1, p2} = deal1(pile, p1, p2)

    # The game begins with the call of this function and it returns the card array of two players
    {p1, p2} = play_round(p1, p2, play_table)

    # checks if both the arrays are empty and returns the pile sorted if so otherwise return either p1 or p2
    if p1 == [] and p2 == [] do
      pile = pile |> Enum.sort(fn a, b -> a >= b end) |> replace_aces2()
      pile
    else
      if p1 == [] do
        p2 = p2 |> Enum.map(fn card -> if card == 14, do: 1, else: card end)

        p2
      else
        p1 = p1 |> Enum.map(fn card -> if card == 14, do: 1, else: card end)

        p1
      end
    end
  end

  # base condition for the deal1 function
  def deal1([], p1, p2), do: {p1, p2}

  # distributes the cards among two players recursively and returns the array of cards of two players when it hits the base condition
  def deal1([c1, c2 | rest], p1, p2) do
    p1 = p1 ++ [c1]
    p2 = p2 ++ [c2]
    deal1(rest, p1, p2)
  end

  # Catches if both the player's arrays are empty
  def play_round(p1, p2, _) when length(p1) == 0 and length(p2) == 0 do
    {p1, p2}
  end

  # Catches if p1 isempty then p2 gets all the cards on the playtable
  def play_round(p1, p2, play_table) when length(p1) == 0 do
    p2 = p2 ++ play_table
    {p1, p2}
  end

  # Catches if p2 isempty then p1 gets all the cards on the playtable
  def play_round(p1, p2, play_table) when length(p2) == 0 do
    p1 = p1 ++ play_table

    {p1, p2}
  end

  def play_round(p1, p2, play_table) do
    # each player puts their top card that is stored in c1 and c2 for player1 and player2 respectively
    [c1 | rest1] = p1
    [c2 | rest2] = p2
    # Top card is removed and players arrays are set to the rest of the cards they have
    p1 = tl(p1)
    p2 = tl(p2)
    # Cards are put on the table i.e, stored in play_table array in descending order
    play_table = play_table ++ [c1, c2]
    play_table = play_table |> Enum.sort(fn a, b -> a >= b end)

    # Player1(P1) wins and gets all the cards on the table
    if c1 > c2 do
      p1 = p1 ++ play_table
      play_table = []

      play_round(p1, p2, play_table)
    else
      # Player2(p2) wins and get all the cards on the table
      if c2 > c1 do
        p2 = p2 ++ play_table
        play_table = []

        play_round(p1, p2, play_table)
      else
        # If its a tie
        # check if both the players have enough(atleast 2) cards to start the war
        if length(rest1) < 2 or length(rest2) < 2 do
          # if not the player having less than 2 cards lose the game
          play_round(p1, p2, play_table)
        else
          # The war starts
          # Top card's taken from each players pile and the other card will be taken due to recursive call making total of 2 cards taken off the top
          play_table = play_table ++ [Enum.at(rest1, 0), Enum.at(rest2, 0)]
          play_table = play_table |> Enum.sort(fn a, b -> a >= b end)
          p1 = tl(rest1)
          p2 = tl(rest2)

          play_round(p1, p2, play_table)
        end
      end
    end
  end

  # Replacer to change the 1's to 14's
  def replace_aces(deck) do
    deck
    |> Enum.map(fn card ->
      if card == 1, do: 14, else: card
    end)
  end

  # Replacer to change the 14's to 1's
  def replace_aces2(deck) do
    deck
    |> Enum.map(fn card ->
      if card == 14, do: 1, else: card
    end)
  end
end
