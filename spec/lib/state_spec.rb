require_relative "../../lib/state"

describe State do
  context "with default arguments" do
    let(:state) { State.new }

    it "has 5 rows" do
      expect(state.rows).to eq(5)
    end

    it "has 5 cols" do
      expect(state.cols).to eq(5)
    end

    it "has 0 humans" do
      expect(state.humans.count).to eq(0)
    end

    it "has 0 zombies" do
      expect(state.zombies.count).to eq(0)
    end

    it "has default 5x5 empty state" do
      expect(state).to match([[nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil]])
    end
  end

  context "validatation" do
    it "raises InvalidRowsOrColumns exception when rows or cols is 0" do
      expect{ State.new(rows: 0) }.to \
        raise_error("InvalidRowsOrColumns")
      expect{ State.new(cols: 0) }.to \
        raise_error("InvalidRowsOrColumns")
      expect{ State.new(rows: 0, cols: 0) }.to \
        raise_error("InvalidRowsOrColumns")
    end

    it "raise OverlappingHumansAndZombies if humans & zombies overlap" do
      expect{ State.new(humans: [[0, 0]], zombies: [[0, 0]]) }.to \
        raise_error("OverlappingHumansAndZombies")
      expect{ State.new(humans: [[0, 1]], zombies: [[0, 0]]) }.not_to \
        raise_error
    end

    it "raises HumansOrZombiesOutOfRange if humans or zombies out of range" do
      expect{ State.new(humans: [[-1, 0]]) }.to \
        raise_error("HumansOrZombiesOutOfRange")
      expect{ State.new(zombies: [[1, 5]]) }.to \
        raise_error("HumansOrZombiesOutOfRange")
      expect{ State.new(humans: [[0, 0]], zombies: [[4, 4]]) }.not_to \
        raise_error
    end
  end

  it "can construct 1x1 empty state" do
    expect(State.new(rows: 1, cols: 1)).to match([[nil]])
  end

  it "can draw 1x1 empty state" do
    expect{ State.new(rows: 1, cols: 1).draw }.to \
      output("###\n" +
             "# #\n" +
             "###\n").to_stdout
  end

  it "can construct 6x6 state with 2 zombies and 2 humans" do
    humans = [[0, 0], [5, 5]]
    zombies = [[5, 0], [0, 5]]
    expect(State.new(rows: 6, cols: 6, humans: humans, zombies: zombies)).to \
      match([["H", nil, nil, nil, nil, "Z"],
             [nil, nil, nil, nil, nil, nil],
             [nil, nil, nil, nil, nil, nil],
             [nil, nil, nil, nil, nil, nil],
             [nil, nil, nil, nil, nil, nil],
             ["Z", nil, nil, nil, nil, "H"]])
  end

  it "can draw 6x6 state with 3 zombies and 2 humans" do
    humans = [[0, 0], [3, 3], [5, 5]]
    zombies = [[5, 0], [0, 5]]
    expect{ State.new(rows: 6, cols: 6, humans: humans,
      zombies: zombies).draw }.to output("########\n" +
                                         "#H    Z#\n" +
                                         "#      #\n" +
                                         "#      #\n" +
                                         "#   H  #\n" +
                                         "#      #\n" +
                                         "#Z    H#\n" +
                                         "########\n").to_stdout
  end

  describe "team movements" do
    it "identify if team memeber can move up" do
      state = State.new(humans: [[0, 0], [4, 0]])
      expect(state.send(:can_move?, [0, 0], :up)).to be_falsy
      expect(state.send(:can_move?, [4, 0], :up)).to be_truthy
    end

    it "identify if team memeber can move down" do
      state = State.new(humans: [[0, 0], [4, 0]])
      expect(state.send(:can_move?, [0, 0], :down)).to be_truthy
      expect(state.send(:can_move?, [4, 0], :down)).to be_falsy
    end

    it "identify if team memeber can move right" do
      state = State.new(humans: [[0, 0], [4, 4]])
      expect(state.send(:can_move?, [0, 0], :right)).to be_truthy
      expect(state.send(:can_move?, [4, 4], :right)).to be_falsy
    end

    it "identify if team memeber can move left" do
      state = State.new(humans: [[0, 0], [4, 4]])
      expect(state.send(:can_move?, [0, 0], :left)).to be_falsy
      expect(state.send(:can_move?, [4, 4], :left)).to be_truthy
    end

    it "moves team member up" do
      state = State.new(humans: [[4, 4]])
      state.send(:move_member, state.humans[0], :up)
      expect(state.humans[0]).to match([3, 4])
    end

    it "moves team member down" do
      state = State.new(humans: [[0, 4]])
      state.send(:move_member, state.humans[0], :down)
      expect(state.humans[0]).to match([1, 4])
    end

    it "moves team member right" do
      state = State.new(humans: [[0, 0]])
      state.send(:move_member, state.humans[0], :right)
      expect(state.humans[0]).to match([0, 1])
    end

    it "moves team member left" do
      state = State.new(humans: [[4, 4]])
      state.send(:move_member, state.humans[0], :left)
      expect(state.humans[0]).to match([4, 3])
    end
  end
end
