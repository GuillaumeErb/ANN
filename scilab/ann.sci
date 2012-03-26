// Artificial Neural Network
// 
// Input : Vector of values (dimension m)
// Output : Vector of result values (dimension n)
//
// The network is a list of matrices (dimension m..d1, ... dn..n),
// where d1...dn are the number of neurons in the several hidden layers.

//***********************************************************************//
// Input/Output functions                                                //
//                                                                       //
//***********************************************************************//

//***********************************************************************//
// loadDimensions : load the dimensions of the layers, stored in path/nb //
//                                                                       //
// Inputs : -path, the path where the network is stored                  //
// Ouputs : -dimensions, a line vector containg dimentions of the layers //
//***********************************************************************//

function[dimensions] = loadDimensions(path)
  dim = read(path + '/nb', 1, 1);
  dimensions = read(path + '/dimensions', 1, dim);
endfunction


//***********************************************************************//
// initialize : Create the matrices representing the network and files   //
// 	      	containing dimensions of the network                     //
//                                                                       //
// Inputs : -path, the path where the network will be stored             //
// 	    -dimensions, the line vector containing the number of neurons//
// 	                 per layer                                       //
// Ouputs : -network, a list of the matrices representing the network    //
//***********************************************************************//

function[network] = initialize(path, dimensions)
  network = list();
  s=size(dimensions);
  for i=1:s(1,2)-1
    m = rand(dimensions(1,i+1), dimensions(1,i));
    write(path + '/matrix' + string(i), m);
    network($+1) = m;
  end
  write(path + '/nb', s(1,2));
  write(path + '/dimensions', dimensions);
  file('close', file());
endfunction


//***********************************************************************//
// load : loading the matrices representing the network from the disk    //
//                                                                       //
// Inputs : -path, the path where the network is stored                  //
// 	    -dimensions, the line vector containing the dimensions of the//
//                       layers, it can be obtained by calling the       //
//                       function loadDimensions                         //
// Ouputs : -network, a list of the matrices representing the network    //
//***********************************************************************//

function[network] = load(path, dimensions)
  network = list();
  s=size(dimensions);
  for i=1:s(1,2)-1
    tmp = read(path+'/matrix'+string(i), dimensions(1,i+1), dimensions(1,i));
    network(i) = tmp;
  end
endfunction


//***********************************************************************//
// store : storing the matrices representing the network on the disk     //
//                                                                       //
// Inputs : -path, the path where the network is stored                  //
// 	    -network, the list of the matrices representing the network  //
// Ouputs : None                                                         //
//***********************************************************************//

function[] = store(path, network)
  for i=1:size(network)-1
    deletefile(path + '/matrix' + string(i));
    write(path + '/matrix' + string(i), network(i));
  end
endfunction


//***********************************************************************//
// sigmoidal : the sigmoidal mathematical function                       //
//***********************************************************************//

function[fx] = sigmoidal(x, c)
  fx = 1/(1+exp(-c*x));
endfunction


//***********************************************************************//
// compute : process the data given and return the results computed      //
//                                                                       //
// Inputs : -input, the vector containing the values of the input neurons//
// 	    -network, the list of the matrices representing the network  //
// Ouputs : -output, a list containing the vectors of the values after   //
//                   each neurons. output(1) is the input of the network //
//***********************************************************************//

function[output] = compute(input, network)
  output = list();
  tmp = input;
  output($+1) = tmp;
  for e=network
    tmp = e*tmp;
    s = size(tmp);
    for i=1:s(1,1)
      tmp(i,1) = sigmoidal(tmp(i,1), 1);
    end
    output($+1) = tmp;
  end
endfunction


//***********************************************************************//
// process : give the results of the execution                           //
//                                                                       //
// Inputs : -path, the location of the network                           //
// 	    -input, the vector of inputs                                 //
// Ouputs : -output, the values given by the output neurons              //
//***********************************************************************//

function[output] = process(path, input)

  dimensions = loadDimensions(path);   
  network = load(path, dimensions);
  output = compute(input, network);
  s = size(output);
  disp(s);
  output = output(s+1);
  
endfunction



//***********************************************************************//
// backpropagation : from the expected output values, propagates back    //
//                   errors of the network and updates it                //
//                                                                       //
// Inputs : -output, a list containing vectors of the neurons' layers    //
//                   output                                              //
// 	    -expectd, the vector containing the expectd output values    //
// 	    -network, the list of the matrices representing the network  //
// 	    -eta, normally set to one, we may increase the speed of the  //
//                updates by increasing this number                      //
// Ouputs : -update, the network updated                                 //
//***********************************************************************//

function[update] = backpropagation(output, expected, network, eta)
  update = network;
  sizeNetwork = size(network);
  out = output(sizeNetwork+1);
  error = out.*(1-out).*(expected-out);
  layer = update(sizeNetwork);
  layer = layer + eta*error*output(sizeNetwork)';
  update(sizeNetwork) = layer;
  
  for i=1:sizeNetwork-1
    out = output(sizeNetwork-i+1);
    error = ((1-out).*out).*(update(sizeNetwork-i+1)'*error);
    layer = update(sizeNetwork-i);
    layer = layer + eta*error*output(sizeNetwork - i)';
    update(sizeNetwork-i) = layer;
  end

endfunction


//***********************************************************************//
// backpropagation : from the expected output values, propagates back    //
//                   errors of the network and updates it                //
//                                                                       //
// Inputs : -intputs, a matrix where each column is an input             //
// 	    -expectd, a matrix where each column is the output we want to//
// 	              make match to the one in the same place of the     //
// 	              inputs                                             //
// 	    -iterationsOut, the number of iteration if the algorithm for //
// 	                    the entire set of inputs                     //
// 	    -iterationsIn, the number of time each input is used by the  //
// 	                   backpropagation algorithm in the inner loop   //
// Ouputs : -update, the network updated                                 //
//***********************************************************************//

function[update] = updateNetwork(inputs, expected, path, ...
				 iterationsOut, iterationsIn)
  funcprot(0);

  s = size(inputs);
  s = s(1,2);
  eta = 1;
  dimensions = loadDimensions(path);   
  network = load(path, dimensions);

  for j=1:iterationsOut
    for i=1:s
      for k=1:iterationsIn
	input = inputs(:,i);
	expect = expected(:,i);
	output = compute(input, network);
	network = backpropagation(output, expect, network, 1);
      end
    end
  end
  update = network;
endfunction
