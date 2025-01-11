function z = Pc(z, l, u)
    % Project z onto the set C={x|l <= x <= u}
    for i = 1:length(z)
        if l(i) <= z(i) && z(i) <= u(i)
            % Do nothing, z(i) is already within bounds
        else
            z(i) = u(i);
        end
    end
end