Plan_1.initialise(1,n_samp +1-(1));

Plan_1.create(MemAllocator, by);

zero(by);

Plan_1.create(MemAllocator, ymat_atmost);

zero(ymat_atmost);

Plan_2.initialise(first_y,last_y+1-(first_y),first_y,last_y+1-(first_y),first_y,last_y+1-(first_y),0,1+1-(0),0,1 +1-(0));

Plan_2.create(MemAllocator, n_comps_ytbsm);

zero(n_comps_ytbsm);

Plan_3.initialise(first_y,last_y+1-(first_y),first_y,last_y+1-(first_y));

Plan_3.create(MemAllocator, n_hs_comps_yy);

zero(n_hs_comps_yy);

Plan_4.initialise(first_y,last_y+1-(first_y),first_y,last_y+1-(first_y),0,1 +1-(0));

Plan_4.create(MemAllocator, n_hs_match_yys);

zero(n_hs_match_yys);

Plan_5.initialise(first_y,last_y+1-(first_y),first_y,last_y+1-(first_y),first_y,last_y+1-(first_y),0,1 +1-(0));

Plan_5.create(MemAllocator, Pr_PO_ytbs);

zero(Pr_PO_ytbs);

Plan_5.create(MemAllocator, Pr_HS_ybbs);

zero(Pr_HS_ybbs);

Plan_4.create(MemAllocator, Pr_HS_bbs);

zero(Pr_HS_bbs);

Plan_5.create(MemAllocator, sqrt_Pr_PO_ytbs);

zero(sqrt_Pr_PO_ytbs);

Plan_6.initialise(first_y,last_y+1-(first_y),0,1 +1-(0));

Plan_6.create(MemAllocator, inv_totfec_ys);

zero(inv_totfec_ys);

Plan_6.create(MemAllocator, N_ys);

zero(N_ys);

Plan_7.initialise(1,n_par +1-(1));

Plan_7.create(MemAllocator, temp_pars);

zero(temp_pars);

Plan_8.initialise(first_y,last_y+1-(first_y),first_y,last_y+1-(first_y),first_y,last_y +1-(first_y));

Plan_8.create(MemAllocator, S_yij);

zero(S_yij);

Plan_1.create(MemAllocator, tcap);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_tcap, (char*)tcap);

Plan_1.create(MemAllocator, a);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_a, (char*)a);

Plan_1.create(MemAllocator, sex);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_sex, (char*)sex);

Plan_9.initialise(1,n_POP +1-(1));

Plan_9.create(MemAllocator, isamp_POP);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_isamp_POP, (char*)isamp_POP);

Plan_9.create(MemAllocator, jsamp_POP);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_jsamp_POP, (char*)jsamp_POP);

Plan_10.initialise(1,n_HS +1-(1));

Plan_10.create(MemAllocator, isamp_HS);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_isamp_HS, (char*)isamp_HS);

Plan_10.create(MemAllocator, jsamp_HS);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_jsamp_HS, (char*)jsamp_HS);

Plan_10.create(MemAllocator, sex_HS);

AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)arg_sex_HS, (char*)sex_HS);

