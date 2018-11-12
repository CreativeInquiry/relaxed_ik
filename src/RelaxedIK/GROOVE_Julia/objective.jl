using ForwardDiff
using Calculus
using ReverseDiff


function obj_master(x, grad, vars, objectives, gradients, weights)
    if length(grad) > 0
        g = zeros(length(grad))
        for i in 1:length(gradients)
            g += weights[i]*gradients[i](x)
        end
        for i = 1:length(grad)
            grad[i] = g[i]
        end
    end

    sum = 0.0
    for i in 1:length(objectives)
        sum += weights[i]*objectives[i](x)
    end
    return sum
end

function get_∇(func, grad_method)
    # func needs to already be a function just with respect to x
    if grad_method == "forward_ad"
        return x->ForwardDiff.gradient(func, x)
    elseif grad_method == "reverse_ad"
        return x->ReverseDiff.gradient(func, x)
    elseif grad_method == "finite_diff"
        return x->Calculus.gradient(func, x)
    end
end


function get_obj_closure(func, vars)
    # takes in an objective function that is dependent on x as well as a vars object, and returns a function that
    #   is only dependent on x
    return x -> func(x, vars)
end
