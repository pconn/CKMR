Plan_1.create(MemAllocator, by);

zero(by);

Plan_1.create(MemAllocator, ymat_atmost);

zero(ymat_atmost);

Plan_3.initialise(first_y,last_y +1-(first_y));

Plan_3.create(MemAllocator, n_obirth_y);

zero(n_obirth_y);

Plan_4.initialise(first_y,last_y+1-(first_y),first_y,last_y +1-(first_y));

Plan_4.create(MemAllocator, n_pmatalive_yt);

zero(n_pmatalive_yt);

Plan_5.initialise(first_y,last_y+1-(first_y),first_y,last_y+1-(first_y),first_y,last_y +1-(first_y));

Plan_5.create(MemAllocator, n_comps_ytb);

zero(n_comps_ytb);

Plan_5.create(MemAllocator, n_PO_ytb);

zero(n_PO_ytb);

Plan_5.create(MemAllocator, Pr_PO_ytb);

zero(Pr_PO_ytb);

Plan_5.create(MemAllocator, sqrt_Pr_PO_ytb);

zero(sqrt_Pr_PO_ytb);

Plan_3.create(MemAllocator, inv_totfec_y);

zero(inv_totfec_y);

Plan_3.create(MemAllocator, n_y);

zero(n_y);

Plan_6.initialise(1,n_par +1-(1));

Plan_6.create(MemAllocator, temp_pars);

zero(temp_pars);

