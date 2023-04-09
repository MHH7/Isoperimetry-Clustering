# n : Number of nodes
# k : Number of parts
# N : Decinding value
# G[v] : Index of child's of node v (Edges are directed from parents to it's childs)
# ans_par[v] : Index of node v's unique parent
# w[v] : Weight of node v
# ind[(u, v)] : Index of edge that goes from u to v
# phi[e] : Weight of edge with index e
# p[v] : Potential of node v
# ans[v] : Number of part that node v is assigned to(initially 0 for all nodes)
# par_ans[v] : 0 if v is an outlier(default), v if this node is head of a component, parent of v o.w

# n, k, N, w[], p[]
# M[][]

function dfs_pre(G, v, mark, tree_ind, temp) # Depth first search on the tree to indexing the nodes for preprocess
    mark[v] = 1 # Marking nodes to avoid double visiting them
    tree_ind[v] = temp # Indexing nodes with dfs order

    for u in G[v]
        if (mark[u] == 0) # Visiting unmarked nodes
            dfs_pre(G, u, mark, tree_ind, temp + 1)

function dfs_cluster(G, v, ans_par, cluster_ind, temp) # Depth first search on the cluster them according to connected components with respect to ans_par array
    cluster_ind[v] = temp # Clustering nodes

    if (cluster_ind[ans_par[v]] == 0) # Visit parent of the node in case it is unvisited
        dfs_cluster(G, ans_par[v], ans_par, cluster_ind, temp)
    for u in G[v]
        if (cluster_ind[u] == 0) #Visiting unmarked nodes
            dfs_cluster(G, u, ans_par, cluster_ind, temp)

function preprocess_Tree(G, primal, n) # Preprocess the nodes to index them in a way that indrex of a node's child is less than it's parent
    G2 = [[] for _ in 1:n] # New list for index of nodes child's according to new indexes
    mark = zeros(n) # Mark array for dfs
    tree_ind = zeros(n) # Indexes of nodes according to dfs order
    
    dfs(G, 1, mark, tree_ind, 1) # Indexing the nodes of the tree(after dfs is done the order is reverse so we build G2 from indexes complement)
    
    for i in 1:n
        for j in G[i]
            if (tree_ind[j] > tree_ind[i]) # Building G2 and adding a nodes child's indexes
                push!(G2[n - tree_ind[i] + 1], n - tree_ind[j] + 1) # (n - tree_ind + 1) is the reversed index of a node
        
        primal[n - tree_ind[i] + 1] = i # Keeping track of the priaml tree's indexes
    
    return G2
    
function make_ans(ans, ans_par, G, n) # Making final answer from ans_par and determinig cluster index of the nodes(-1 for the outliers)
    temp = 1 # Counter for the number of current cluster

    for i in 1:n
        if (ans[i] != 0) # Skiping processed nodes
            continue
        
        if (ans_par[i] == 0)
            ans[i] = -1
        else
            dfs_cluster(G, i, ans_par, ans, temp)
            temp += 1

function dp_tree() # Main part of the algorithm, fills ans_par array and returns it as the final value
    
end
 
cur = 1 # Index of current part

for i in 1:n # Iterate from bottom to top of the tree and calculate ans for all nodes
    v = i
    
    for u in G[v] # Iterate on v's childs to update relevant values
        e = ind[(v, u)]
        if p[u] + phi[e] <= N * w[u] # Case 1: Cut node u and its children from above and make a new component
            ans_par[u] = u
            p[v] = p[v] + phi[e]
            cur = cur + 1
        elseif p[u] - phi[e] < N * w[u] # Case 2: Connect node u to node v
            ans_par[u] = v
            w[v] = w[v] + w[u]
            p[v] = p[v] + p[u]
        else # Case 3: Node u is an outlier
            p[v] = p[v] + phi[e]


end

# If j = k, there is an answer, o.w there is no answer.
