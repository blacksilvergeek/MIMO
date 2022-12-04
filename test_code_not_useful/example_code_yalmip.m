x = sdpvar(1)

% Can any solver be called?
optimize(x>= 0, x,sdpsettings('debug',1))

% Problems with a specific solver?
optimize(x>= 0, x,sdpsettings('debug',1,'solver','thissolver'))