# n : Number of nodes
# k : Numer of parts
# c[e] : Weight of edge with index e
# up[e] : Upper node related to edge with index e
# down[e] : Lower node related to edge with index e
# w_sub[v] : Sum of the v's subtree nodes weight
#
# gamma[u][k][l] : Minimum edge expansion of the first part(which includes u) among all k-partition's with at most l outliers and
#                 every parts expansion is less than xi (the edge to the parent of u is not included)  
#
# mu[u][k][l] : Equals 1 if there exists a k-partition in the subtree of u with at most l outliers and 
#               every part expansion is less than xi, 0 o.w 
#
# par[v] : Index of the edge that connects node v to its parent
#
# U[i][k][l] : Equals 1 if there exists a k-partition of the fixed node v and it's first i children, while v is an outlier itself
#              and the number of outliers are at most l and the expansion of each partition less than xi
#
# X[i][k][l] : Minimum cost that i'th children of node v can add to satisfy the fixed node v with k parts, each one with expansion 
#              less than xi and at most l outliers
#
# Y[i][k][l] : Minimum cost for the fixed node v and it's first i children to have k parts, eachone with expansion less than xi
#              and together at most l outliers
#

function epsilon(e, xi) # Returns the value related to cutting the edge with index e
    return (xi * w_sub[down[e]] + c[e]) 

# Algorithm 1
for i in 1:d
    for l in 0:lambda
        for k in 0:kappa
            if mu[u[i]][k - 1][l] == 1 and epsilon(par[i], xi) <= gamma[u[i]][k][l]
                X[i][k][l] = epsilon(par[i], xi)
            else
                X[i][k][l] = gamma[u[i]][k][k]
                
for k in 1:kappa
    for l in 0:lambda
        Y[1][k][l] = X[1][k][l]
for i in 2:d
    for l in 0:lambda
        for k in 1:kappa
            Y[i][k][l] = inf
            for l_prime in 0:l
                for k_prime 1:k
                    Y[i][k][l] = min(Y[i][k][l], Y[i - 1][k_prime][l_prime] + X[i][k + 1 - k_prime][l - l_prime])
for k in 1:kappa
    for l in 0:lambda
        gamma[u][k][l] = Y[d][k][l]

# Algorithm 2
for l in 0:lambda
    for k in 1:kappa
        mu[u][k][l] = 0
        if gamma[u][k][l] <= xi * w[u] - c[e]
            mu[u][k][l] = 1
for k in 0:kappa
    for l in 0:lambda
        U[1][k][l] = mu[u1][k][l]
for i in 2:d
    for l in 0:lambda
        for k in 0:kappa
            if mu[u][k][l] == 0
                U[i][k][l] = 0
                for l_prime in 0:l - 1
                    for k_prime in 0:k
                        if U[i - 1][k_prime][l_prime] == 1 && U[i - 1][k_prime][l_prime] == mu[ui][k - k_prime][l - 1 - l_prime]
                            U[i][k][l] = 1
                            break
for k in 0:kappa
    for l in 0:lambda
        if U[d][k][l] == 1
            mu[u][k][l] = 1

#Algorithm 3

