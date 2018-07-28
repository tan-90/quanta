import * as React from 'react';
import {Route, HashRouter, Switch} from 'react-router-dom';
import {Hello} from './Hello';

export class Router extends React.Component<{}, {}>
{
    render()
    {
        return(
            <HashRouter>
                <Switch>
                    <Route path='/hello' component={Hello}/>
                </Switch>
            </HashRouter>
        );
    }
}
