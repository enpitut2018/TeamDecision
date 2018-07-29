require 'matrix'

class MakeTeamSolver
  # p: チーム分けの基準となるパラメータ。降順でソートしておく
  # n: チーム数
  def initialize(p, n)
    @P = p
    @N = n
    @W = p.size / n + (p.size.modulo(n) == 0 ? 0 : 1)# チームあたりの最大ユーザ数
  end

  # w: チームあたりのユーザ数
  # m: ユーザ数
  def solve()
    return X(@N, @P.size).to_a
  end

  # チームテーブルを返す
  # 貪欲法で解く# n: チーム数
  def X(n, m)
    if (n == m)
        return Matrix::I n
    else
        x = X(n, m - 1)
        q = x * Vector[*@P[0..(m-2)]]
        return Matrix::columns [*(x.column_vectors), Vector::basis(size: n, 
            index: q.each_with_index.select {|i|
              t = x.row(i[1])
              t.inner_product(t) < @W
            }.min[1])]
    end
  end
end
