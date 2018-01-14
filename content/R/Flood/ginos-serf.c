/////LITERATURE - Serfling
  double logX[sampSize];
  int iLog;
  for(iLog=0; iLog<=sampSize; iLog++)
    {
      logX[iLog] = log(sample[iLog]);
    }
          int combos = 10;
  if(sampSize == 10)
    combos = 10;
  else if(sampSize == 25)
    {
      //combos = 2042975;
      combos = 100000;
    }
  else if((sampSize == 100) || (sampSize == 500))
58
    {
      //combos = 10000000;
      combos = 100000;
}
  double intermMu[combos]; //holds the intermediate Mu’s
  double intermSig[combos]; //holds the intermediate Sigma’s
  int combosMatrix[combos][9];
  int iSerf = 0;
  int count9 = 0;
  int indexMatrix1 = 0;
  int indexMatrix2 = 0;
  for(iSerf = 0; iSerf < combos; iSerf++)
    {
      for(count9 = 0; count9 < 9; count9++)
{
  int ranNum = floor(sampSize * gsl_ran_flat(r, 0.0, 1.0));
  if(count9==0)
    {
      index9[count9] = ranNum;
    }
  int ranNumIndex = 0;
  //loop through to make sure that we haven’t already used this index
  for(ranNumIndex = 0; ranNumIndex < count9; ranNumIndex++)
  {
    if(index9[ranNumIndex]==ranNum)
      {
ranNumIndex = count9;
count9 = count9-1; // we go back to find another number because this one
                   // has already been used.
      }
    else if(ranNumIndex==(count9-1))
      {
index9[count9] = ranNum;
      }
  } //end for-loop
  if(count9==8)
    {
      gsl_sort_int(index9,1,9);
      for(indexMatrix1=0; indexMatrix1 < iSerf; indexMatrix1++)
{
  for(indexMatrix2=0; indexMatrix2 < 9; indexMatrix2++)
    {
      if(combosMatrix[indexMatrix1][indexMatrix2] != index9[indexMatrix2])
{
  int iNew = 0;
  for(iNew = 0; iNew<9; iNew++)
{

combosMatrix[iSerf][iNew] = index9[iNew];
    }
  indexMatrix1 = iSerf+1;
  indexMatrix2 = 9;
}
      else if((indexMatrix1==8) && (indexMatrix2==(iSerf-1)))
// we haven’t found a new combination
{
  count9 = 0; // causes us to find new indeces which we haven’t already used...
}
    } // end for(indexMatrix2=0...)
} // end for(indexMatrix1=0...)
    } // end if(count9==8)
} //end for(count9=0...)
      // we only get to this point if we have found a new combination...:
      int aSerf = index9[0];
      int bSerf = index9[1];
      int cSerf = index9[2];
      int dSerf = index9[3];
      int eSerf = index9[4];
      int fSerf = index9[5];
      int gSerf = index9[6];
      int hSerf = index9[7];
      int jSerf = index9[8];
      double meanAll9 = (logX[aSerf] + logX[bSerf] + logX[cSerf] +
                         logX[dSerf] + logX[eSerf] + logX[fSerf] +
                         logX[gSerf] + logX[hSerf] + logX[jSerf])/9;
      intermMu[iSerf] = meanAll9;
      intermSig[iSerf] = (pow((logX[aSerf] - meanAll9),2) +
             pow((logX[bSerf] - meanAll9),2) + pow((logX[cSerf] - meanAll9),2) +
             pow((logX[dSerf] - meanAll9),2) + pow((logX[eSerf] - meanAll9),2) +
             pow((logX[fSerf] - meanAll9),2) + pow((logX[gSerf] - meanAll9),2) +
             pow((logX[hSerf] - meanAll9),2) + pow((logX[jSerf] - meanAll9),2))/9;
}
  gsl_sort(intermMu,1,combos);
  gsl_sort(intermSig,1,combos);
  muHat[2][m] = gsl_stats_median_from_sorted_data(intermMu,1,combos);
  sigmaHat[2][m] = gsl_stats_median_from_sorted_data(intermSig,1,combos);
  sigmaHat[2][m] = pow(sigmaHat[2][m],0.5);