class Ability
  include CanCan::Ability

  def initialize(user)

    # Menú de configuración: OK
    # Creación de empresas: OK

    empresa_usuario = user.enterprise

    # Usuario administrador, tiene acceso a todo:
    if user.has_role? ROLE_ADMIN
        can :manage, :all
    # Usuario evaluador, tiene acceso a todo, pero sólo de su propia empresa?:
    elsif user.has_role? ROLE_EVAL
        can :manage, :all
	else

		# Usuario de gobierno de TI, tiene acceso a dicho modulo, y sólo a su propia empresa: OK
		if user.has_role? ROLE_USER_GOV
			can :manage, Mapas::GovernanceDecision, :enterprise_id => empresa_usuario.id
			can :manage, Escenarios::RiskEscenario, :enterprise_id => empresa_usuario.id
			can :manage, Escenarios::GoalEscenario, :enterprise_id => empresa_usuario.id
			can :manage, GovernanceStructure, :enterprise_id => empresa_usuario.id
			can :create, Mapas::GovernanceDecision
			can :create, GovernanceResponsability
			can :manage, Risk, :enterprise_id => empresa_usuario.id
			can :manage, Mapas::DecisionMap, :enterprise_id => empresa_usuario.id
			can :manage, Escenarios::PriorizationEscenario, :enterprise_id => empresa_usuario.id
		end
		
		# Usuario de configuracion, tiene acceso a dicho modulo, y solo a su propia empresa: OK
		if user.has_role? ROLE_USER_CONFIG
			can :manage, Configuracion, :enterprise_id => empresa_usuario.id
            can :riskmap, Configuracion
			can :read, GovernanceStructure, :enterprise_id => empresa_usuario.id
		end
		
		# Usuario de simulacion, tiene acceso a dicho modulo, y sólo a su propia empresa: OK
		if user.has_role? ROLE_USER_SIMULATION
			can :inicio, Simulacion::Escenario
			can :manage, Simulacion::Escenario, :enterprise_id => empresa_usuario.id
		end
	end
    



    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
