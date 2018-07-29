class MakeTeamSolver
  # p: チーム分けの基準となるパラメータ
  # n: チーム数
  def initialize(p, n)
    @p = p
    @n = n
  end

  # w: チームあたりのユーザ数
  # m: ユーザ数
  def solve()
    ut = [nil] * @p.size
    team = Array.new(@n) {[]}
    mean = @p.sum / @n.to_f
    loop do
      (0...@n).sort_by {|i|
        (team[i].sum - mean).abs
      }.reverse.each {|i|
        return ut if ut.all?
        u = ut.each_with_index.select {|j|
          j.include? nil
        }.min_by {|j|
          (team[i].sum + @p[j[1]] - mean).abs
        }
        ut[u[1]] = i
        team[i] << @p[u[1]]
      }
    end
  end
end
