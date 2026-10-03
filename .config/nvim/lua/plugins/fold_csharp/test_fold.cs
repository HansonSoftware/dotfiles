/*
require("plugins.fold_csharp.debug").clear(0)
*/
public class Rule
{
    public class NestedClass
    {
        public string componentTypeName;
        public string DisplayName => "hello";

        public string Description
        {
            get;
            set;
        }

        string _type;
        public string Type
        {
            get
            {
                //
                //
                //
            }

            private set
            {
                //
            }
        }

        public NestedClass()
        {
            //
        }

        public void Other()
        {
            //
        }
        public void Other()
        {
            //
        }

        public void Other()
        {
            //
        }

        public bool IgnoreField(Type componentType, FieldInfo fieldInfo)
        {
            //
        }

        public (string x, bool y) FirstOther()
        {
            //
        }

        public (string x, bool y) SecondOther()
        { }

        public (string x, bool y) ThirdOther() { }

        public (string x, bool y) FourthOther()
        {
            //
        }
    }

    public string componentTypeName;
    public string DisplayName => "hello";

#if TEST
    [Obsolete]
#endif
    public string Description
    {
        get;
        set;
    }

    string _type;
    public string Type
    {
        get
        {
            //
            //
            //
        }

        private set
        {
            //
        }
    }

    public Rule()
    {
        //
    }

    public void Other()
    {
        //
        for (int i = 0; i < 20; i++)
        {
            continue;
            break;
            return;
        }
        //
    }

#if TEST
    [Obsolete]
#endif
    public bool IgnoreField(Type componentType, FieldInfo fieldInfo)
    {
        //
        //
    }

    public (string x, bool y) FirstOther()
    {
        //
    }

    public (string x, bool y) SecondOther()
    { }

    public (string x, bool y) ThirdOther() { }

    public (string x, bool y) FourthOther()
    {
        //
    }
}

