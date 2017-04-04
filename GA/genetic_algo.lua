--This code created by AI team Austin Auger, Michael Tillett, Catherine Dougherty
--for use in a similar project. This skeleton is being used as a test for implementation of a 
--Artificial Neural Network and most if not all code present will not be used.
--All below required files were created by the same team.

require "candidate"
require "other_utils"

function ga_crossover(tbl, topperc)
    --extract top x perc from table
    local top = {};
    local top_max_ind = math.floor(topperc*(#tbl));
    local top_max_cont = #(tbl[1].inputs);
    for i=1, top_max_ind do
        top[i] = gen_candidate.new();
        for j=1, top_max_cont do
            top[i].inputs[j] = deepcopy(tbl[i].inputs[j]);
            top[i].input_fit = tbl[i].input_fit;
        end
    end
    --inject new generation into old table
    local max_cont = #(tbl[1].inputs);
    for i=1, #tbl do
        local p1 = math.random(1,top_max_ind);
        local p2 = math.random(1,top_max_ind);
        for j = 1, max_cont do
            if top[p1].input_fit[j] > top[p2].input_fit[j] then
                tbl[i].inputs[j] = deepcopy(top[p1].inputs[j]);
            else
                tbl[i].inputs[j] = deepcopy(top[p2].inputs[j]);
            end
            tbl[i].input_fit[j] = 0;
        end
    end
end


function ga_mutate(tbl, count, mutation_rate)
    local rand_max = 1/mutation_rate;
    for i=1, count do
        for j=1, #(tbl[i].inputs) do
            if math.random(1, rand_max) == 1 then
                tbl[i].inputs[j] = generate_input();
            end
        end
    end
end